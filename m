Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758AbaKDJBE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 04:01:04 -0500
Received: from canardo.mork.no ([148.122.252.1]:35662 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223AbaKDJBB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 04:01:01 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Stephanie Wallick <stephanie.s.wallick@intel.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 00/10] MA USB drivers cover letter
Organization: m
References: <1415047377-3139-1-git-send-email-stephanie.s.wallick@intel.com>
Date: Tue, 04 Nov 2014 10:00:32 +0100
In-Reply-To: <1415047377-3139-1-git-send-email-stephanie.s.wallick@intel.com>
	(Stephanie Wallick's message of "Mon, 3 Nov 2014 12:42:47 -0800")
Message-ID: <877fzbs5lb.fsf@nemi.mork.no>
User-Agent: Gnus/5.130011 (Ma Gnus v0.11) Emacs/24.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.9 (canardo.mork.no [IPv6:2001:4641::1]); Tue, 04 Nov 2014 10:00:39 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[added linux-usb@vger.kernel.org Cc]

Stephanie Wallick <stephanie.s.wallick@intel.com> writes:

> Media Agnostic (MA) USB enables the USB protocol to be used over a wide
> range of physical media. MA USB is a relatively new protocol and is
> currently unsupported in the Linux kernel. This patch set adds the
> following drivers with the following capabilities:
>
> 1) MA USB Host:
>         - provides functionality of a USB Host Controller.
>         - implements MA USB protocol for a MA USB host.
>         - provides MA USB packet transport over TCP
>
> 2) MA USB Device:
>         - provides functionality of a USB Device Controller.
>         - implements MA USB protocol for a MA USB device.
>         - provides MA USB packet transport over TCP

Nice.  But don't you think this deserves the attention of the linux-usb
mailing list?  Yes, Greg's attention is of course good to have too :-)
But  I believe this is of interest to more people, who might not read
everything on linux-kernel.

Has there been any thought/discussion about the relationship to the
existing usbip drivers, which just moved out of staging? Is a usbip
userspace compatibility layer feasible sometime in the future?


Bjørn
