Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118AbaKEUjY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 15:39:24 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53001 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbaKEUjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 15:39:20 -0500
Date: Wed, 5 Nov 2014 21:39:18 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Sebastian Reichel <sre@kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, freemangordon@abv.bg
Subject: Re: N900 modem support in 3.18-rc1
Message-ID: <20141105203918.GA29199@amd>
References: <20141104205117.GA17606@amd>
 <20141105011122.GA30622@earth.universe>
 <20141105203151.GA24636@amd>
 <201411052137.31452@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201411052137.31452@pali>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Hello, have you enabled CONFIG_PHONET?

Yes:

CONFIG_PHONET=y

And this:

# SPI Protocol Masters                                                                            
#                                                                                                 
# CONFIG_SPI_SPIDEV is not set                                                                    
# CONFIG_SPI_TLE62X0 is not set                                                                   
# CONFIG_SPMI is not set                                                                          
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#                                                                                                 
# HSI controllers                                                                                 
#                                                                                                 
CONFIG_OMAP_SSI=y
CONFIG_OMAP_SSI_PORT=y

#                                                                                                 
# HSI clients                                                                                     
#                                                                                                 
CONFIG_NOKIA_MODEM=y
CONFIG_SSI_PROTOCOL=y
CONFIG_HSI_CHAR=y
CONFIG_HSI_CMT_SPEECH=y

Best regards,
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
