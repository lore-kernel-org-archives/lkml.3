Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546AbaBFXeB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 18:34:01 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:61091 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751066AbaBFXdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 18:33:42 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Peter Wu <lekensteyn@gmail.com>
Cc: Bastien Traverse <bastien.traverse@gmail.com>,
        linux-kernel@vger.kernel.org, francis.moro@gmail.com,
        linux-pm@vger.kernel.org
Subject: Re: 3.12: ethernet controller missing after resuming from suspend to RAM
Date: Fri, 07 Feb 2014 00:48:14 +0100
Message-ID: <2082735.jaKtCS1gqS@vostro.rjw.lan>
User-Agent: KMail/4.11.4 (Linux/3.13.0+; KDE/4.11.4; x86_64; ; )
In-Reply-To: <1396879.yH0LySDBlU@al>
References: <52F2CC7B.80406@gmail.com> <55671594.HynIX0trOC@vostro.rjw.lan> <1396879.yH0LySDBlU@al>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 07, 2014 12:27:03 AM you wrote:
[...]

> [   49.170694] video LNXVIDEO:01: Restoring backlight state
> [   49.644845] ACPI: \_SB_.AC__: ACPI_NOTIFY_BUS_CHECK event: unsupported
> [   49.646671] jme 0000:04:00.5: irq 50 for MSI/MSI-X
> [   49.671645] jme 0000:04:00.5 eth0: Link is down

Well, this means that Ethernet device is present after the resume.

> [   49.671717] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
> [   49.674119] iwlwifi 0000:05:00.0: L1 Enabled; Disabling L0S
> [   49.681037] iwlwifi 0000:05:00.0: Radio type=0x1-0x3-0x1
> [   49.778035] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [   49.806241] xhci_hcd 0000:02:00.0: no hotplug settings from platform
> [   49.859417] iwlwifi 0000:05:00.0: no hotplug settings from platform
> [   56.264694] wlan0: authenticate with [STRIPPED]
> [   56.277969] wlan0: send auth to [STRIPPED] (try 1/3)
> [   56.282076] wlan0: authenticated
> [   56.283879] wlan0: associate with [STRIPPED] (try 1/3)
> [   56.297196] wlan0: RX AssocResp from [STRIPPED] (capab=0x411 status=0 aid=6)
> [   56.303746] wlan0: associated
> [   56.303826] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready

Can you check the lspci differences between before/after the suspend-resume
cycle?

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
