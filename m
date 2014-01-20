Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbaATKVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 05:21:46 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:42643 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752167AbaATKVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 05:21:44 -0500
Date: Mon, 20 Jan 2014 10:21:29 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sebastian Reichel <sre@ring0.de>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Anton Vorontsov <anton@enomsg.org>,
        Michael Trimarchi <michael@amarulasolutions.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        freemangordon@abv.bg, aaro.koskinen@iki.fi, pavel@ucw.cz
Subject: Re: [PATCH v2 2/3] bq2415x_charger: Use power_supply notifier for
	automode
Message-ID: <20140120102129.GO27282@n2100.arm.linux.org.uk>
References: <1378630239-10006-1-git-send-email-pali.rohar@gmail.com> <1384856285-19593-3-git-send-email-pali.rohar@gmail.com> <CAOf5uwkrep0PhOn67+9PHmP2A2Jxrp9DNK3BRp9D_sYu_PYvvw@mail.gmail.com> <201311242001.23126@pali> <CAOf5uw=-cy2QoDxjecxYTYsrQRD=LtN0N7DcYJHZ6HSbexzPRw@mail.gmail.com> <20131201223730.GD6271@lizard> <CAOf5uwnkQwkS7_fsLtC5nzdXyS1Rzw2SkxaziUuJrO9SKXh3yw@mail.gmail.com> <20131202002444.GA22418@teo> <CAOf5uwnz6SfeEsbGq62QFgRHJ2ys++VV1+VrULxyR4uH2Z_vJQ@mail.gmail.com> <20140119205402.GA24185@earth.universe>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140119205402.GA24185@earth.universe>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And another one using that evil mail-followup-to header:

Mail-Followup-To: Pali Rohár <pali.rohar@gmail.com>,
        Anton Vorontsov <anton@enomsg.org>,
        Michael Trimarchi <michael@amarulasolutions.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        freemangordon@abv.bg, aaro.koskinen@iki.fi, pavel@ucw.cz

which results in all the above being moved into the To: header by
unsuspecting recipients who reply to your message.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
