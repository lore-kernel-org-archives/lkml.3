Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872Ab3K2PXY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 10:23:24 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:58273 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753582Ab3K2PXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 10:23:23 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Fengguang Wu <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: kernel panic due to "PCI / ACPI: Use acpi_find_child_device() for child devices lookup"
Date: Fri, 29 Nov 2013 16:36:14 +0100
Message-ID: <2390176.NvKRoZECqu@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1662528.KAt6bvD9Oc@vostro.rjw.lan>
References: <20131129052552.GC23378@yliu-dev.sh.intel.com> <1662528.KAt6bvD9Oc@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 29, 2013 04:33:00 PM Rafael J. Wysocki wrote:
> On Friday, November 29, 2013 01:25:52 PM Yuanhan Liu wrote:
> > Greetings,
> > 
> > We got the follow kernel panic dmesg(full dmesg is attached):
> 
> That patch has been updated in linux-next recently, can you please
> check if you are able to reproduce the problem with the new version?

I mean in linux-pm.git/linux-next.

Thanks,
Rafael

