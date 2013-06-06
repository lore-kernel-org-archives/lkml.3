Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101Ab3FFSpf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 14:45:35 -0400
Received: from vps1.hno.se ([31.192.227.87]:40339 "EHLO vps1.hno.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971Ab3FFSpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 14:45:34 -0400
Message-ID: <1370544282.31564.5.camel@localhost>
Subject: Re: [Arm-netbook] getting allwinner SoC support upstream (was Re:
 Uploading linux (3.9.4-1))
From: Henrik =?ISO-8859-1?Q?Nordstr=F6m?= <henrik@henriknordstrom.net>
To: Linux on small ARM machines <arm-netbook@lists.phcomp.co.uk>
Cc: devicetree-discuss <devicetree-discuss@ozlabs.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        debian-arm@lists.debian.org, "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        ARM Linux Mailing List <linux-arm-kernel@lists.infradead.org>,
        debian-kernel@lists.debian.org
Date: Thu, 06 Jun 2013 20:44:42 +0200
In-Reply-To: <CAPweEDzrYL5c9v1T=nTcyv9RPrJ-TEnCyyjpHQnhXXJY-32=5g@mail.gmail.com>
References: <CAPweEDx3mAy40BZrzrKPRbvg7vKMj7KevDQ3m_v4p6Yo50eSGg@mail.gmail.com>
	 <CAKON4OxDD5orX2w-_+d5kawTGXbE3KKj2QLERo9m7=NiUSXhgQ@mail.gmail.com>
	 <51AFA6DD.3000202@wwwdotorg.org>
	 <CAPweEDz=hFxXW3XF9CSNZpEFSjayb5an1E8Xze1_uQcCZONVxg@mail.gmail.com>
	 <1370469574.18839.33.camel@localhost>
	 <CAPweEDxMpeJc-w=Yd7d2OT=UisRBp2rxf-MPMDUCOG3EyJz1GQ@mail.gmail.com>
	 <CAKON4OxwyV2f_iTEb5RnP_azc7EsSxPdku_TY5WLWxN7USiY1Q@mail.gmail.com>
	 <CAPweEDw1BabE0cmT5fxZ3Z9p9EH508M3Nzcqk2VcO0oz-qYsvg@mail.gmail.com>
	 <CAKON4Oz79hUE_ReAqjeynwL6ZWntX2W1uw3YOg0G2AiY7Gjs=g@mail.gmail.com>
	 <CAPweEDyO+Sc1aQ64HBeh1OSzmPNsnwMwEo5kbHSan5vw_YEjXA@mail.gmail.com>
	 <1370477756.20454.65.camel@localhost>
	 <CAPweEDzrYL5c9v1T=nTcyv9RPrJ-TEnCyyjpHQnhXXJY-32=5g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tor 2013-06-06 klockan 13:19 +0100 skrev luke.leighton:

>  mass-volume tablet, mass-volume IPTV box.  android OS, nothing else.

Which still includes a number of possible configurations with different
i2c, spi, usb etc devices connected on the board. Because Allwinner is
not using mainline methods for configuration their customers are stuck
in only selecting between a very limited set of "Allwinner compatible"
auxillary chips (g-sensors, led controls, wifi modules, gps modules etc)
in their designs.

By using DT their customers are free to choose any device supported
mainline.

Regards
Henrik

