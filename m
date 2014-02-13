Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbaBMJaU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 04:30:20 -0500
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:56336 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753102AbaBMJaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 04:30:17 -0500
Message-ID: <1392283815.30853.11.camel@x220>
Subject: Re: blackfin: Kconfig symbol VIDEO_MT9M114?
From: Paul Bolle <pebolle@tiscali.nl>
To: Steven Miao <realmz6@gmail.com>
Cc: Sonic Zhang <sonic.zhang@analog.com>, Richard Weinberger <richard@nod.at>,
        adi-buildroot-devel@lists.sourceforge.net,
        "open list:CAN NETWORK DRIVERS <linux-can@vger.kernel.org>, open "
	 "list:NETWORKING DRIVERS <netdev@vger.kernel.org>, open list" 
	<linux-kernel@vger.kernel.org>
Date: Thu, 13 Feb 2014 10:30:15 +0100
In-Reply-To: <CAMk6uBk+jPpDOwN6C+xkuhWB1b3EGxb205-JhnK2JZhZMvVn2w@mail.gmail.com>
References: <1392200311.23759.27.camel@x220>
	 <CAMk6uBk+jPpDOwN6C+xkuhWB1b3EGxb205-JhnK2JZhZMvVn2w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Feb 2014 09:30:15.0295 (UTC) FILETIME=[339DB0F0:01CF289E]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

On Thu, 2014-02-13 at 17:00 +0800, Steven Miao wrote:
> VIDEO_MT9M114 is from patch "Aptina mt9m114 HD digital image sensor
> driver", but unfortunately this patch hasn't been accepted yet.
> https://patchwork.linuxtv.org/patch/16308/
> This Kconfig symbol should be removed until the mt9m114 driver is
> accepted by mainline.

Thanks for looking into this.

It's easy for me to submit a trivial patch to remove the one line
depending on these Kconfig macros. But it seems that line should be
added to the queue for that driver at the same time, otherwise we risk
losing it. So it's safer if you or the people working on that driver
coordinate that, isn't it?


Paul Bolle

