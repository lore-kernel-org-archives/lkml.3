Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757159AbaD2JYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 05:24:21 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50571 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756462AbaD2JYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 05:24:17 -0400
Date: Tue, 29 Apr 2014 11:24:15 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sebastian Reichel <sre@kernel.org>
Cc: Sebastian Reichel <sre@ring0.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, linux-input@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 4/5] Input: tsc2005: add DT support
Message-ID: <20140429092415.GG19146@xo-6d-61-c0.localdomain>
References: <1398470179-20880-1-git-send-email-sre@kernel.org>
 <1398470179-20880-5-git-send-email-sre@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398470179-20880-5-git-send-email-sre@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2014-04-26 01:56:18, Sebastian Reichel wrote:
> This adds DT support to the tsc2005 touchscreen
> driver.
> 
> Signed-off-by: Sebastian Reichel <sre@kernel.org>

> @@ -100,6 +102,11 @@
>  					 TSC2005_CFR2_AVG_7)
>  
>  #define MAX_12BIT			0xfff
> +#define TSC2005_DEF_X_FUZZ		4
> +#define TSC2005_DEF_Y_FUZZ		8
> +#define TSC2005_DEF_P_FUZZ		2
> +#define TSC2005_DEF_RESISTOR		280
> 

IMO using defines insteaed of plain numbers does not help readability much,
but ....

Reviewed-by: Pavel Machek <pavel@ucw.cz>


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
