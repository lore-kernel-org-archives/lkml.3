Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332Ab3ANXpN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 18:45:13 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:40815 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757089Ab3ANXpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 18:45:10 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Toshi Kani <toshi.kani@hp.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>
Subject: Re: [PATCH 0/5] ACPI: Rework acpi_bus_trim()
Date: Tue, 15 Jan 2013 00:51 +0100
Message-ID: <2049836.kZAJsepFIG@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAE9FiQUbQVdxDxD68ktZhFuJYs861-aFEXjTOgee1ueEous2eQ@mail.gmail.com>
References: <3885603.ydrrB7OEKf@vostro.rjw.lan> <CAE9FiQUbQVdxDxD68ktZhFuJYs861-aFEXjTOgee1ueEous2eQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 14, 2013 02:21:38 PM Yinghai Lu wrote:
> On Mon, Jan 14, 2013 at 1:33 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > The next three patches actually rework acpi_bus_trim() in three steps:
> >
> > [3/5] Drop the second argument of acpi_bus_trim() (all callers pass 1 in there
> >       anyway.
> > [4/5] Reimplement acpi_bus_trim() using acpi_walk_namespace().
> > [3/5] Make acpi_bus_trim() carry out two passes as described above.
> >
> > I'm aware of the fact that this will conflict with the patches that Yinghai
> > posted a few days ago, but in my opinion the changes here are prerequisite for
> > the Yinghai's patchset.
> 
> Sure, I will drop my change to acpi_bus_trim() and update one
> reference accordingly.
> 
> Acked-by: for those 5 patches.

Thanks!

> So you will put those patches in acpi-scan, and Bjorn will pull that
> again to pci tree?

I'm going to put them into acpi-scan some time later this week, but I'd like
them to go through linux-next first to catch teething problems, if any.

I can't speak for Bjorn, though.  I suppose he will pull them if you ask him to.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
