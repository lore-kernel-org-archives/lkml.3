Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865AbaKJRIG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 12:08:06 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:58540 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456AbaKJRIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 12:08:04 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+caO57WWFPmdHq3Cx3D0E8
Date: Mon, 10 Nov 2014 09:07:18 -0800
From: Tony Lindgren <tony@atomide.com>
To: NeilBrown <neilb@suse.de>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, GTA04 owners <gta04-owner@goldelico.com>
Subject: Re: [PATCH] ARM: OMAP: serial: remove last vestige of DTR_gpio
 support.
Message-ID: <20141110170718.GM31454@atomide.com>
References: <20141108104246.1f2da822@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141108104246.1f2da822@notabene.brown>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* NeilBrown <neilb@suse.de> [141107 15:44]:
> 
> These fields were added by:
> commit 9574f36fb801035f6ab0fbb1b53ce2c12c17d100
>     OMAP/serial: Add support for driving a GPIO as DTR.
> 
> but not removed by
> 
> commit 985bfd54c826c0ba873ca0adfd5589263e0c6ee2
>     tty: serial: omap: remove some dead code
> 
> which reverted most of that commit.
> Time to revert the rest.

Thanks applying into omap-for-v3.19/fixes-not-urgent.

Tony
