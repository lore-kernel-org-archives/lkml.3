Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbaCXPyQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 11:54:16 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38165 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750999AbaCXPyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 11:54:14 -0400
Date: Mon, 24 Mar 2014 16:54:12 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Hans-Christian Egtvedt'" <egtvedt@samfundet.no>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "'Nicolas Ferre'" <nicolas.ferre@atmel.com>,
        "'Jean-Christophe Plagniol-Villard'" <plagnioj@jcrosoft.com>,
        "'Haavard Skinnemoen'" <hskinnemoen@gmail.com>,
        "'Bryan Wu'" <cooloney@gmail.com>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "'Thierry Reding'" <thierry.reding@gmail.com>,
        linux-leds@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-fbdev@vger.kernel.org
Subject: Re: [PATCH 14/16] backlight: atmel-pwm-bl: remove obsolete driver
Message-ID: <20140324155412.GA9083@piout.net>
References: <1395234209-15546-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1395234209-15546-15-git-send-email-alexandre.belloni@free-electrons.com>
 <20140319142231.GF20872@samfundet.no>
 <000101cf449f$aa609960$ff21cc20$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000101cf449f$aa609960$ff21cc20$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 21/03/2014 at 09:51:16 +0900, Jingoo Han wrote :
> On Wednesday, March 19, 2014 11:23 PM, Hans-Christian Egtvedt wrote:
> > Around Wed 19 Mar 2014 14:03:27 +0100 or thereabout, Alexandre Belloni wrote:
> > > The atmel-pwm-bl driver is now obsolete. It is not used by any mainlined boards
> > > and is replaced by the generic pwm_bl with the pawm-atmel driver using the
> > > generic PWM framework.
> > >
> > > Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> > 
> > Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
> 
> Acked-by: Jingoo Han <jg1.han@samsung.com>
> 

You didn't comment on patch 08/16, are you fine with it ? I guess this
is the only one holding back the full series.

Regards,

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
