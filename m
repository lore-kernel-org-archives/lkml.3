Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751731AbaKKSuQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 13:50:16 -0500
Received: from mail-ig0-f170.google.com ([209.85.213.170]:62393 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbaKKSuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 13:50:14 -0500
MIME-Version: 1.0
In-Reply-To: <20141111042324.GF28161@google.com>
References: <1415325580-5974-1-git-send-email-yinghai@kernel.org>
	<20141111042324.GF28161@google.com>
Date: Tue, 11 Nov 2014 10:50:13 -0800
X-Google-Sender-Auth: r6-9FEbW0x2I_1ZIVPa3U2SWW8g
Message-ID: <CAE9FiQWxbPXLB-Dc9x9VLQgxKPih+ixBq+WKNcPAKuYE31DtcA@mail.gmail.com>
Subject: Re: [PATCH] PCI: Apply _HPX link control for all supported pcie device
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 8:23 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>
> But I don't want to move pcie_cap_has_lnkctl() to pci.h and leave
> pcie_cap_has_sltctl() and pcie_cap_has_rtctl() in access.c.  They're all
> related, so I think they should stay together.
>
> What if we left them in access.c, made them non-static, non-inline, and
> just added prototypes to pci.h?  Or I guess we could add a prototype just
> for pcie_cap_has_lnkctl(), since that's the only one we need so far.

Ok, will have another version that add only prototype for
pcie_cap_has_lnkctl() to pci.h

Thanks

Yinghai
