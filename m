Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724Ab3KSUio (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 15:38:44 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:65023 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751727Ab3KSUil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 15:38:41 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        "Moore, Robert" <robert.moore@intel.com>,
        Toshi Kani <toshi.kani@hp.com>, Yinghai Lu <yinghai@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Aaron Lu <aaron.lu@intel.com>, Lv Zheng <lv.zheng@intel.com>
Subject: Re: [PATCH 0/10] ACPI: Device objects for all namespace nodes and PCI root hotplug integration
Date: Tue, 19 Nov 2013 21:51:19 +0100
Message-ID: <3736594.HRILCo6Ms2@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20131119143046.GL2281@intel.com>
References: <1421028.Rsfpmhnym3@vostro.rjw.lan> <20131119143046.GL2281@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 19, 2013 04:30:46 PM Mika Westerberg wrote:
> On Sun, Nov 17, 2013 at 05:29:41PM +0100, Rafael J. Wysocki wrote:
> > This is 3.14 material, but I'm posting it today to let you know it is coming.
> > Of course, if you see any immediate problems with the following patches, please
> > let me know.
> 
> For what it's worth, I have tested this series on three different systems
> that have Thunderbolt and it still works fine after the series has been
> applied :)

Awesome, thanks!

I hope you won't mind if I add your Tested-by to the series. :-)

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
