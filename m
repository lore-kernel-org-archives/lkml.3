Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161737AbaJaClu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 22:41:50 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:46642 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161558AbaJaClt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 22:41:49 -0400
Date: Fri, 31 Oct 2014 03:40:44 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 09/15] net: dsa: Add support for switch EEPROM access
Message-ID: <20141031024044.GA4082@lunn.ch>
References: <1414604707-22407-1-git-send-email-linux@roeck-us.net>
 <1414604707-22407-10-git-send-email-linux@roeck-us.net>
 <20141030211131.GB32139@lunn.ch>
 <20141030223951.GA19489@roeck-us.net>
 <20141031010039.GA29492@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141031010039.GA29492@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> As suspected, ethtool will attempt to read a zero-length eeprom.
> 
> The following patch should solve the problem. Not sure if it is worth it,
> though, since this will change behavior for existing drivers.

Yes, it changes behaviour, but it does make it more consistent.

Probably it should be up to core network people to decide if this is
the write fix or leave it as is.

    Andrew
