Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952AbaFRVxE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 17:53:04 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:59471 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbaFRVxC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 17:53:02 -0400
MIME-Version: 1.0
In-Reply-To: <201406182220.22818@pali>
References: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com>
	<201406182122.29623@pali>
	<20140618200053.GK32514@n2100.arm.linux.org.uk>
	<201406182220.22818@pali>
Date: Wed, 18 Jun 2014 18:53:00 -0300
Message-ID: <CAOMZO5DZSxeTC9fKYXk6XBAG-03qW+TM_8HS_3M8Mkbd-iEdzg@mail.gmail.com>
Subject: Re: [PATCH] ARM: /proc/cpuinfo: Use DT machine name when possible
From: Fabio Estevam <festevam@gmail.com>
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Sebastian Reichel <sre@debian.org>, Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Pavel Machek <pavel@ucw.cz>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 5:20 PM, Pali Rohár <pali.rohar@gmail.com> wrote:
>
> So how to read Revision and Serial number in DT based kernel?

$ cat /sys/bus/soc/devices/soc0/soc_id
i.MX6SX

$ cat /sys/bus/soc/devices/soc0/revision
1.0

$ cat /sys/bus/soc/devices/soc0/machine
Freescale i.MX6 SoloX SDB Board
