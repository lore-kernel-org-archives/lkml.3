Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932676AbaIEN6h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 09:58:37 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:54425 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932418AbaIEN6g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 09:58:36 -0400
MIME-Version: 1.0
In-Reply-To: <201409051552.05447@pali>
References: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com>
	<201409051338.40988@pali>
	<20140905134542.GD20164@leverpostej>
	<201409051552.05447@pali>
Date: Fri, 5 Sep 2014 10:58:34 -0300
Message-ID: <CAOMZO5BtUaYbQUhidgyPBFdARsFY=uYySYqXXmFEfPL8qTBbfQ@mail.gmail.com>
Subject: Re: [PATCH] ARM: /proc/cpuinfo: Use DT machine name when possible
From: Fabio Estevam <festevam@gmail.com>
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Russell King <linux@arm.linux.org.uk>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Sebastian Reichel <sre@debian.org>, Will Deacon <Will.Deacon@arm.com>,
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

On Fri, Sep 5, 2014 at 10:52 AM, Pali Rohár <pali.rohar@gmail.com> wrote:

> So what is your suggestion for identifing board (name/type) which
> will work with any kernel (and will not be broken again by kernel
> later)?

$ cat /sys/bus/soc/devices/soc0/machine
Freescale i.MX6 Quad SABRE Smart Device Board
