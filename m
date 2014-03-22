Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751203AbaCVL2Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 07:28:25 -0400
Received: from www.linutronix.de ([62.245.132.108]:54912 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbaCVL2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 07:28:20 -0400
Message-ID: <532D73D1.7020408@linutronix.de>
Date: Sat, 22 Mar 2014 12:28:17 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.3.0
MIME-Version: 1.0
To: delicious quinoa <delicious.quinoa@gmail.com>
CC: Alan Tull <atull@altera.com>, Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dinh Nguyen <dinguyen@altera.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 3/3] ARM: dts: socfpga: add gpio pieces
References: <1395345324-18299-1-git-send-email-bigeasy@linutronix.de>	<1395345324-18299-4-git-send-email-bigeasy@linutronix.de>	<CANk1AXRa4V1ADNaT+T3pYF4zyxni9Y8rmU9UYRoA_7NxW8KWEg@mail.gmail.com> <CANk1AXSQVFZvRmvYt+JF+TDVpfX-_RLiUcQXotGzpHoTMUVymQ@mail.gmail.com>
In-Reply-To: <CANk1AXSQVFZvRmvYt+JF+TDVpfX-_RLiUcQXotGzpHoTMUVymQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2014 11:15 PM, delicious quinoa wrote:
> snps,nr-gpios = <27>;
> 
> As noted on other thread, gpio2 is 27 wide, despite what the
> documentation says.  When I made that change and remove your other two
> patches the gpios worked for me on a cyclone5 devkit board.
> 
> So if you fix the "#gpio-cells = <2>;" for all 3 gpios and fix
> "snps,nr-gpios = <27>;" for gpio2, then this one patch looks good to
> me.  With these changes,

Okay will do. And I also add a note that  the reference manual is wrong
here.

> 
> Acked-by: Alan Tull <atull@altera.com>
> 
> Alan Tull
> aka
> delicous quinoa

Sebastian
