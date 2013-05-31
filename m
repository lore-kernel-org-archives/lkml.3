Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751657Ab3EaJCQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 05:02:16 -0400
Received: from mail1.bemta5.messagelabs.com ([195.245.231.148]:55100 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751334Ab3EaJCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 05:02:06 -0400
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-16.tower-178.messagelabs.com!1369990923!25032349!1
X-Originating-IP: [83.171.138.125]
X-StarScan-Received: 
X-StarScan-Version: 6.9.6; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Fri, 31 May 2013 11:02:03 +0200
Date: Fri, 31 May 2013 11:04:07 +0200
From: Johannes Thumshirn <johannes.thumshirn@men.de>
To: <wim@iguana.be>
CC: <linux-watchdog@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 1/2] watchdog: New watchdog driver for MEN A21
 watchdogs
Message-ID: <20130531090406.GA7256@jtlinux>
References: <20130531085842.GA8572@jtlinux>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130531085842.GA8572@jtlinux>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [192.1.1.31]
X-OriginalArrivalTime: 31 May 2013 09:02:03.0413 (UTC) FILETIME=[84997C50:01CE5DDD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 10:58:48AM +0200, Johannes Thumshirn wrote:
> This patch adds the driver for the watchdog devices found on MEN Mikro
> Elektronik A21 VMEbus CPU Carrier Boards. It has DT-support and uses the
> watchdog framework.
[...]
> +MODULE_DESCRIPTION("MEN A21 Watchdog");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:a21-watchdog");
> --
> 1.7.9.5
>


Args, sorry messed up the thread :-(.

I'm not so firm with using mutt for patches, but git send-email doesn't seem
to like Exchange here...


Johannes
