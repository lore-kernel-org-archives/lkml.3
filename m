Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757Ab3FEXkq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 19:40:46 -0400
Received: from vps1.hno.se ([31.192.227.87]:34600 "EHLO vps1.hno.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846Ab3FEXkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 19:40:45 -0400
Message-ID: <1370475609.20454.44.camel@localhost>
Subject: Re: [Arm-netbook] getting allwinner SoC support upstream (was Re:
 Uploading linux (3.9.4-1))
From: Henrik =?ISO-8859-1?Q?Nordstr=F6m?= <henrik@henriknordstrom.net>
To: Linux on small ARM machines <arm-netbook@lists.phcomp.co.uk>
Cc: "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        devicetree-discuss <devicetree-discuss@ozlabs.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        debian-arm@lists.debian.org,
        ARM Linux Mailing List <linux-arm-kernel@lists.infradead.org>,
        debian-kernel@lists.debian.org
Date: Thu, 06 Jun 2013 01:40:09 +0200
In-Reply-To: <CAPweEDw1BabE0cmT5fxZ3Z9p9EH508M3Nzcqk2VcO0oz-qYsvg@mail.gmail.com>
References: <CAPweEDx3mAy40BZrzrKPRbvg7vKMj7KevDQ3m_v4p6Yo50eSGg@mail.gmail.com>
	 <CAKON4OxDD5orX2w-_+d5kawTGXbE3KKj2QLERo9m7=NiUSXhgQ@mail.gmail.com>
	 <51AFA6DD.3000202@wwwdotorg.org>
	 <CAPweEDz=hFxXW3XF9CSNZpEFSjayb5an1E8Xze1_uQcCZONVxg@mail.gmail.com>
	 <1370469574.18839.33.camel@localhost>
	 <CAPweEDxMpeJc-w=Yd7d2OT=UisRBp2rxf-MPMDUCOG3EyJz1GQ@mail.gmail.com>
	 <CAKON4OxwyV2f_iTEb5RnP_azc7EsSxPdku_TY5WLWxN7USiY1Q@mail.gmail.com>
	 <CAPweEDw1BabE0cmT5fxZ3Z9p9EH508M3Nzcqk2VcO0oz-qYsvg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tor 2013-06-06 klockan 00:26 +0100 skrev luke.leighton:

>  no john - they've only added it to the multiplexed sections of the
> drivers which they themselves have written.  such as
> drivers/usb/sun{N}i_usb/*.[ch], drivers/block/nand/sun{N}_i,
> arch/arm/mach-sun{N}i and so on.

And a number of SPI device drivers, USB device drivers, vendor provided
device drivers, ......

> the script.fex system deals with the pinmux issue in a very neat way that:
> 
>   a) has very little impact on the rest of the kernel tree [citation
> needed!  i'm saying that: could someone please confirm if it's true]

Not really the case. Actually the opposite. DT have this as well, and
integrated in device probing. Allwinner need to hack every driver used
to add their gpio requests to have pinmuxing triggered.

It is just layered a bit differently when using DT.

Regards
Henrik

