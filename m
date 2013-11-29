Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991Ab3K2PUK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 10:20:10 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:49835 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754519Ab3K2PUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 10:20:08 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Fengguang Wu <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: kernel panic due to "PCI / ACPI: Use acpi_find_child_device() for child devices lookup"
Date: Fri, 29 Nov 2013 16:33 +0100
Message-ID: <1662528.KAt6bvD9Oc@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20131129052552.GC23378@yliu-dev.sh.intel.com>
References: <20131129052552.GC23378@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 29, 2013 01:25:52 PM Yuanhan Liu wrote:
> Greetings,
> 
> We got the follow kernel panic dmesg(full dmesg is attached):

That patch has been updated in linux-next recently, can you please
check if you are able to reproduce the problem with the new version?

Rafael

