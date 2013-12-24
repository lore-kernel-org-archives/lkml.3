Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758260Ab3LXCkf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 21:40:35 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:37866 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757917Ab3LXCkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 21:40:33 -0500
Date: Mon, 23 Dec 2013 18:35:16 -0800
From: Anton Vorontsov <anton@enomsg.org>
To: Sebastian Reichel <sre@debian.org>
Cc: Tony Lindgren <tony@atomide.com>, David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Subject: Re: [PATCHv2 0/2] DT support for isp1704-charger
Message-ID: <20131224023515.GD10223@lizard>
References: <20131114175227.GH10317@atomide.com>
 <1385859611-26532-1-git-send-email-sre@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1385859611-26532-1-git-send-email-sre@debian.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 01, 2013 at 02:00:09AM +0100, Sebastian Reichel wrote:
> This is the second iteration of the isp1704 DT patches.
> 
> Changes since v1:
>  * reword the binding documentation slightly according
>    to the suggestions of Mark Rutland
>  * keep supporting the set_power callback and leave the
>    board code in its current state. This solves potential
>    merge problems. The additional code can be removed in
>    the next merge window.

Applied, thanks a lot!

Anton
