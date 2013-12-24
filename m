Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008Ab3LXCDw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 21:03:52 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:54871 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817Ab3LXCDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 21:03:50 -0500
Date: Mon, 23 Dec 2013 17:58:28 -0800
From: Anton Vorontsov <anton@enomsg.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, freemangordon@abv.bg, aaro.koskinen@iki.fi
Subject: Re: [PATCH v2 2/3] bq2415x_charger: Use power_supply notifier for
 automode
Message-ID: <20131224015828.GB10223@lizard>
References: <1378630239-10006-1-git-send-email-pali.rohar@gmail.com>
 <1384856285-19593-1-git-send-email-pali.rohar@gmail.com>
 <1384856285-19593-3-git-send-email-pali.rohar@gmail.com>
 <20131119132416.GE14587@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131119132416.GE14587@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 02:24:16PM +0100, Pavel Machek wrote:
> On Tue 2013-11-19 11:18:04, Pali Rohár wrote:
> > This patch removing set_mode_hook function from board data and replacing it with
> > new string variable of notifier power supply device. After this change it is
> > possible to add DT support because driver does not need specific board function
> > anymore. Only static data and name of power supply device is required.
> > 
> > Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> 
> Reviewed-by: Pavel Machek <pavel@ucw.cz>

Applied, thanks!

Anton
