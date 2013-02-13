Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029Ab3BMEVM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 23:21:12 -0500
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:36663 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab3BMEVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 23:21:09 -0500
Message-ID: <1360725515.3642.1.camel@thor.lan>
Subject: Re: [PATCH] ACPI, PCI: Get PRT entry during acpi_pci_enable_irq()
From: Peter Hurley <peter@hurleysoftware.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 12 Feb 2013 22:18:35 -0500
In-Reply-To: <CAE9FiQUp4oKSpZ8Y-M-+n_y=mBs_t4cdKLhgG8xZSPgteZcgkQ@mail.gmail.com>
References: <CAE9FiQUkmnV_On5+ZpH2pF4Li1HxLpkO8bp4TnYB46=pc9Safg@mail.gmail.com>
	 <1360696283-20313-1-git-send-email-yinghai@kernel.org>
	 <1360722010.3604.3.camel@thor.lan>
	 <CAE9FiQUp4oKSpZ8Y-M-+n_y=mBs_t4cdKLhgG8xZSPgteZcgkQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-12 at 18:42 -0800, Yinghai Lu wrote:
> On Tue, Feb 12, 2013 at 6:20 PM, Peter Hurley <peter@hurleysoftware.com> wrote:
> >
> > Reported-and-tested-by: Peter Hurley <peter@hurleysoftware.com>
> 
> Thanks.
> 
> > PS - I just happened to see this version on the list. Would you please
> > cc me on any future versions?
> 
> oh, my fault. I take it for granted that "git send-email" will pick
> that email from
> patch just like Cc.

No problem. Actually, I'm sorry it took this long for me to test. I was
stuck in an epic bisect that I eventually abandoned at the 41st test
with it still in merge bases.


