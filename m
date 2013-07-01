Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440Ab3GAN2G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 09:28:06 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49670 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752695Ab3GAN2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 09:28:04 -0400
X-Sasl-enc: ripcOubun5/hUj8ZszE0dAvytcQuAnoqYfrts9MJOdp4 1372685283
Date: Mon, 1 Jul 2013 10:28:00 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Pavel Machek <pavel@ucw.cz>
Cc: Mark Lord <kernel@start.ca>, Ondrej Zary <linux@rainbow-software.org>,
        Mark Lord <mlord@pobox.com>,
        Marcus Overhagen <marcus.overhagen@gmail.com>,
        kernel list <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
        tj@kernel.org
Subject: Re: SATA hdd refuses to reallocate a sector?
Message-ID: <20130701132800.GA11841@khazad-dum.debian.net>
References: <20130623101940.GA4448@amd.pavel.ucw.cz>
 <51C76858.4060906@pobox.com>
 <20130623215100.GA7414@amd.pavel.ucw.cz>
 <201306240914.29502.linux@rainbow-software.org>
 <20130629184716.GA9330@khazad-dum.debian.net>
 <51CF6776.7090206@start.ca>
 <20130630143427.GA10035@khazad-dum.debian.net>
 <20130630164956.GA26305@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130630164956.GA26305@amd.pavel.ucw.cz>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Jun 2013, Pavel Machek wrote:
> > > > You know, either the "long" or the "offline" SMART test routines do exactly
> > > > that on any spinning rust device with a firmware that is not utterly broken.
> > > > 
> > > > The HDD's firmware will rewrite, and even reallocate any "weak" sectors
> > > > found by the surface scan.
> > > > 
> > > 
> > > The drives I have tried this on (smartctl -t long),
> > > abort at the first bad sector.  Not useful.
> > 
> > Which vendor?  The Seagates I have on hand are not that crappy, for example
> > (their issues are subpar mechanics and the resulting high rate of failure,
> > but the firmware at least is not a piece of crap)...
> 
> Are you sure? I seem to have firmware issues:
> 
> === START OF INFORMATION SECTION ===
> Model Family:     Seagate Momentus 5400.6 series

Apparently there is too much of a difference between Seagate Momentus and
Seagate Barracuda.  The barracuda are not crap [as far as the firmware
goes], where apparently the Momentus have crap firmware.

So we're both correct, and I was not precise enough when I spoke well of
Seagate firware :-)

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
