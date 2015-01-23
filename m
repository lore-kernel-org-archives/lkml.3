Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927AbbAWAyc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 19:54:32 -0500
Received: from sonata.ens-lyon.org ([140.77.166.138]:33393 "EHLO
	sonata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338AbbAWAya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 19:54:30 -0500
Date: Fri, 23 Jan 2015 01:54:24 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, David Herrmann <dh.herrmann@gmail.com>,
        akpm@linux-foundation.org, jslaby@suse.cz,
        Bryan Wu <cooloney@gmail.com>, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org, Evan Broder <evan@ebroder.net>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Sascha Hauer <s.hauer@pengutronix.de>, Rob Clark <robdclark@gmail.com>,
        Niels de Vos <devos@fedoraproject.org>,
        linux-arm-kernel@lists.infradead.org, blogic@openwrt.org,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Subject: Re: [PATCHv5 2/2] INPUT: Introduce generic trigger/LED pairs to
 input LEDs
Message-ID: <20150123005424.GA2869@type.youpi.perso.aquilenet.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Pavel Machek <pavel@ucw.cz>, David Herrmann <dh.herrmann@gmail.com>,
	akpm@linux-foundation.org, jslaby@suse.cz,
	Bryan Wu <cooloney@gmail.com>, rpurdie@rpsys.net,
	linux-kernel@vger.kernel.org, Evan Broder <evan@ebroder.net>,
	Arnaud Patard <arnaud.patard@rtp-net.org>,
	Peter Korsgaard <jacmet@sunsite.dk>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Rob Clark <robdclark@gmail.com>,
	Niels de Vos <devos@fedoraproject.org>,
	linux-arm-kernel@lists.infradead.org, blogic@openwrt.org,
	Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
References: <20141226232116.GA5069@type>
 <1756449.aIckN0M451@dtor-glaptop>
 <20150123004429.GD3123@type.youpi.perso.aquilenet.fr>
 <4596566.1GHUcIZaFc@dtor-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4596566.1GHUcIZaFc@dtor-glaptop>
User-Agent: Mutt/1.5.21+34 (58baf7c9f32f) (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov, le Thu 22 Jan 2015 16:51:16 -0800, a écrit :
> No. Please take a look at other users of platform data. Platform is the box we 
> are running on, not parent device. Platform data is supposed to be constant,
> not changing between driver runs.

Ok, well, then we can just use to_input_dev(cdev->dev->parent); to
access the input_dev from the led_classdev cdev.

Samuel
