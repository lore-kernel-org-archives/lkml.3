Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757798Ab3BSHlw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 02:41:52 -0500
Received: from webbox1416.server-home.net ([77.236.96.61]:50662 "EHLO
	webbox1416.server-home.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757252Ab3BSHlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 02:41:51 -0500
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Felipe Balbi <balbi@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: SYSFS "errors"
Date: Tue, 19 Feb 2013 08:41:47 +0100
Message-ID: <2721602.qxhJKWaVil@ws-stein>
User-Agent: KMail/4.9.5 (Linux/3.6.11-gentoo+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130218174916.GA2070@kroah.com>
References: <20130218153316.GA2663@arwen.pp.htv.fi> <20130218172700.GH2663@arwen.pp.htv.fi> <20130218174916.GA2070@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 February 2013 09:49:16, Greg KH wrote:
> > Invalid argument - /sys/devices/virtual/net/lo/speed
> > Invalid argument - /sys/devices/virtual/net/lo/duplex

This is even true for ethernet devices which do not have a link currently or non-ethernet devices (e.g. CAN).
> LANG=C cat /sys/class/net/enp1s8/speed
> cat: /sys/class/net/enp1s8/speed: Invalid argument
> ethtool enp1s8 | grep -A1 Speed
>         Speed: Unknown!
>         Duplex: Unknown! (255)
> LANG=C cat /sys/class/net/can0/speed
> cat: /sys/class/net/can0/speed: Invalid argument

Regards,
Alexander

