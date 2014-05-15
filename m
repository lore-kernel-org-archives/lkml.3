Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765AbaEOJkJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 05:40:09 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:57022 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235AbaEOJkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 05:40:06 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=
Content-Transfer-Encoding: 7bit
Date: Thu, 15 May 2014 11:39:41 +0200
From: Stefan Agner <stefan@agner.ch>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Thierry Reding <thierry.reding@gmail.com>, swarren@wwwdotorg.org,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, marcel@ziswiler.com
Subject: Re: [PATCH v2 2/3] drm/panel: add support for EDT panels
In-Reply-To: <1400146519.4102.30.camel@paszta.hi.pengutronix.de>
References: <cover.1400103181.git.stefan@agner.ch>
 <35c081171a3d9a9401767601c02a12e266b37dd0.1400103181.git.stefan@agner.ch>
 <20140515075102.GE5952@ulmo> <4de1d09b7873e012e43525c1f8ab9c66@agner.ch>
 <20140515091220.GC6434@ulmo>
 <1400146519.4102.30.camel@paszta.hi.pengutronix.de>
Message-ID: <cc51075ad7c00d6b08d28834d651b198@agner.ch>
User-Agent: Roundcube Webmail/1.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2014-05-15 11:35, schrieb Philipp Zabel:
> Am Donnerstag, den 15.05.2014, 11:12 +0200 schrieb Thierry Reding:
<snip>
>> I also noticed that Philipp's patch doesn't actually introduce the
>> device tree bindings, so that will have to be added as well.
> 
> Hmm, yes. Should I take over the edt,et070080dh6.txt from Stefan's
> series and repost all, or can I just hand in the missing
> edt,etm0700g0dh6.txt separately?

Just sent a revision of my patch which doesn't contain that text file
anymore, hence for me it would be preferable if you can add both
files...

--
Stefan
