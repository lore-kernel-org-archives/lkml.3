Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914Ab3FFSw3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 14:52:29 -0400
Received: from vps1.hno.se ([31.192.227.87]:44357 "EHLO vps1.hno.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693Ab3FFSw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 14:52:28 -0400
Message-ID: <1370544712.31564.11.camel@localhost>
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
Date: Thu, 06 Jun 2013 20:51:52 +0200
In-Reply-To: <CAPweEDyPffcN9cNJ10ZHt+AZJHTRdU0LMfCGM_756uAbf+NEBQ@mail.gmail.com>
References: <CAPweEDx3mAy40BZrzrKPRbvg7vKMj7KevDQ3m_v4p6Yo50eSGg@mail.gmail.com>
	 <CAKON4OxDD5orX2w-_+d5kawTGXbE3KKj2QLERo9m7=NiUSXhgQ@mail.gmail.com>
	 <51AFA6DD.3000202@wwwdotorg.org>
	 <CAPweEDz=hFxXW3XF9CSNZpEFSjayb5an1E8Xze1_uQcCZONVxg@mail.gmail.com>
	 <1370469574.18839.33.camel@localhost>
	 <CAPweEDxMpeJc-w=Yd7d2OT=UisRBp2rxf-MPMDUCOG3EyJz1GQ@mail.gmail.com>
	 <CAKON4OxwyV2f_iTEb5RnP_azc7EsSxPdku_TY5WLWxN7USiY1Q@mail.gmail.com>
	 <CAPweEDw1BabE0cmT5fxZ3Z9p9EH508M3Nzcqk2VcO0oz-qYsvg@mail.gmail.com>
	 <1370475609.20454.44.camel@localhost>
	 <CAPweEDwS3tR=wh-bZJb3vqR8fVQra=3XxDitowGRdH9c7WRfmQ@mail.gmail.com>
	 <1370477958.20454.68.camel@localhost>
	 <CAPweEDyPffcN9cNJ10ZHt+AZJHTRdU0LMfCGM_756uAbf+NEBQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tor 2013-06-06 klockan 13:22 +0100 skrev luke.leighton:

>  idea: hook into devicetree gpio functions to allow script-fex gpio
functions to gain access in a separate module?  that sort of thing.

No. Drop FEX from the kernel, use DT. There is no reason why the kernel
shold care about the FEX format.

Translate from FEX to DT where needed in the "firmware" image build
process to allow Allwinner to keep the FEX as hardware description to
the ODMs.

Regards
Henrik

