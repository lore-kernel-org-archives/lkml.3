Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757613Ab3DALGs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 07:06:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39029 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294Ab3DALGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 07:06:47 -0400
Subject: Re: gpio-ucb1400
From: Jean Delvare <jdelvare@suse.de>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
In-Reply-To: <201303311919.06030.marek.vasut@gmail.com>
References: <1364586399.4216.312.camel@amber.site>
	 <201303302020.44584.marek.vasut@gmail.com>
	 <20130330232559.GA12864@roeck-us.net>
	 <201303311919.06030.marek.vasut@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Suse Linux
Date: Mon, 01 Apr 2013 13:06:43 +0200
Message-ID: <1364814403.4943.7.camel@amber.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 31 mars 2013 à 19:19 +0200, Marek Vasut a écrit :
> Dear Guenter Roeck,
> > Jean is absolutely right - it should get fixed, or the driver should be
> > dropped if no one is using it anyway.
> 
> I think ARM/palmtc was using this.

My point was, the upstream gpio-ucb1400 driver in its current form is
unusable (on top of being ugly.) I have no doubt that someone used that
driver successfully in some external kernel tree, but the code that was
merged upstream is incomplete and no good.

-- 
Jean Delvare
Suse L3

