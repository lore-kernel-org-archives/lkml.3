Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991Ab3F3Oef (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 10:34:35 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:35430 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751652Ab3F3Oec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 10:34:32 -0400
X-Sasl-enc: jbA7TvsjPcaK/9XJ4YsaxAl8TpNmhUhWlwcAaMICxil+ 1372602870
Date: Sun, 30 Jun 2013 11:34:27 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Mark Lord <kernel@start.ca>
Cc: Ondrej Zary <linux@rainbow-software.org>, Pavel Machek <pavel@ucw.cz>,
        Mark Lord <mlord@pobox.com>,
        Marcus Overhagen <marcus.overhagen@gmail.com>,
        kernel list <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
        tj@kernel.org
Subject: Re: SATA hdd refuses to reallocate a sector?
Message-ID: <20130630143427.GA10035@khazad-dum.debian.net>
References: <20130623101940.GA4448@amd.pavel.ucw.cz>
 <51C76858.4060906@pobox.com>
 <20130623215100.GA7414@amd.pavel.ucw.cz>
 <201306240914.29502.linux@rainbow-software.org>
 <20130629184716.GA9330@khazad-dum.debian.net>
 <51CF6776.7090206@start.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51CF6776.7090206@start.ca>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Jun 2013, Mark Lord wrote:
> On 13-06-29 02:47 PM, Henrique de Moraes Holschuh wrote:
> > You know, either the "long" or the "offline" SMART test routines do exactly
> > that on any spinning rust device with a firmware that is not utterly broken.
> > 
> > The HDD's firmware will rewrite, and even reallocate any "weak" sectors
> > found by the surface scan.
> > 
> 
> The drives I have tried this on (smartctl -t long),
> abort at the first bad sector.  Not useful.

Which vendor?  The Seagates I have on hand are not that crappy, for example
(their issues are subpar mechanics and the resulting high rate of failure,
but the firmware at least is not a piece of crap)...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
