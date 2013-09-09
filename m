Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526Ab3IIDX0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 23:23:26 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:53111 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458Ab3IIDXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 23:23:25 -0400
MIME-Version: 1.0
In-Reply-To: <1378696187-4359-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1378696187-4359-1-git-send-email-michael.opdenacker@free-electrons.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Mon, 9 Sep 2013 08:52:44 +0530
Message-ID: <CALkWK0mgk4ryO6h=CrWDjQ2bFtg=YY7dS1pJ1JqgX2Oo04wD8Q@mail.gmail.com>
Subject: Re: [PATCH] xen: remove deprecated IRQF_DISABLED
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, xen-devel@lists.xenproject.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Opdenacker wrote:
> diff --git a/drivers/xen/platform-pci.c b/drivers/xen/platform-pci.c
> index 99db9e1..2f3528e 100644
> --- a/drivers/xen/platform-pci.c
> +++ b/drivers/xen/platform-pci.c
> @@ -84,7 +84,7 @@ static irqreturn_t do_hvm_evtchn_intr(int irq, void *dev_id)
>  static int xen_allocate_irq(struct pci_dev *pdev)
>  {
>         return request_irq(pdev->irq, do_hvm_evtchn_intr,
> -                       IRQF_DISABLED | IRQF_NOBALANCING | IRQF_TRIGGER_RISING,
> +                       IRQF_NOBALANCING | IRQF_TRIGGER_RISING,

This is a good patch, although that one day might be far in the future.
