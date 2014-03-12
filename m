Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667AbaCLK5t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 06:57:49 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33053 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753224AbaCLK5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 06:57:48 -0400
Date: Wed, 12 Mar 2014 11:57:46 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Josh Wu <josh.wu@atmel.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH 1/3] iio: adc: at91_adc: Repair broken platform_data
 support
Message-ID: <20140312105746.GK13905@piout.net>
References: <1394038675-15809-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1394038675-15809-2-git-send-email-alexandre.belloni@free-electrons.com>
 <5318C950.7060900@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5318C950.7060900@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonathan,

On 06/03/2014 at 19:15:28 +0000, Jonathan Cameron wrote :
> It's late in the cycle so I'll send this on to Greg KH with a note
> to say either send it to Linus if he is happy doing so - or send
> it early in 3.15, then it'll get picked up for stable.
> 
> I'll give it a day or so to see if I the at91 maintainers are happy
> with the other two parts as it is probably cleaner if all 3 go together.
> 
> Applied to the fixes-togreg branch of iio.git
> 

I don't recall seeing you sending that to Greg. Could you do that, along
with the two other patches that got acked by Nicolas ?

Anyway, if it is too late, we'll push for stable.

Thanks !

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
