Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436AbaJYTQj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 15:16:39 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:43679 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752395AbaJYTQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 15:16:37 -0400
Date: Sat, 25 Oct 2014 16:01:16 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Andrew Lunn <andrew@lunn.ch>, Florian Fainelli <f.fainelli@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/14] net: dsa: Add support for hardware monitoring
Message-ID: <20141025140116.GA12051@lunn.ch>
References: <CAGVrzcYjPJWai9bxkh+WRrEEAzBKBd-LQm7zDeeouxngr_v9SQ@mail.gmail.com>
 <54488CE1.2000106@roeck-us.net>
 <20141023134706.GB25190@lunn.ch>
 <20141023162754.GA21343@roeck-us.net>
 <20141023165459.GE25190@lunn.ch>
 <20141023173847.GA22988@roeck-us.net>
 <20141023180357.GG25190@lunn.ch>
 <20141023184322.GA24281@roeck-us.net>
 <20141023195526.GH25190@lunn.ch>
 <20141024161919.GA29600@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141024161919.GA29600@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Here is another naming option:
> 
> em1dsa0-virtual-0

I prefer this over isa.

However, i think there should be some sort of separator between the
network device name and dsa.

	Andrew
