Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933238Ab3FFMvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 08:51:24 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:44613 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932403Ab3FFMvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 08:51:22 -0400
Message-ID: <51B085C6.3000605@gmail.com>
Date: Thu, 06 Jun 2013 14:51:18 +0200
From: Vladimir Pantelic <vladoman@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:20.0) Gecko/20100101 Firefox/20.0 SeaMonkey/2.17
MIME-Version: 1.0
To: Linux on small ARM machines <arm-netbook@lists.phcomp.co.uk>
CC: devicetree-discuss <devicetree-discuss@ozlabs.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        debian-arm@lists.debian.org, "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        ARM Linux Mailing List <linux-arm-kernel@lists.infradead.org>,
        debian-kernel@lists.debian.org
Subject: Re: [Arm-netbook] getting allwinner SoC support upstream (was Re:
 Uploading linux (3.9.4-1))
References: <CAPweEDx3mAy40BZrzrKPRbvg7vKMj7KevDQ3m_v4p6Yo50eSGg@mail.gmail.com> <CAKON4OxDD5orX2w-_+d5kawTGXbE3KKj2QLERo9m7=NiUSXhgQ@mail.gmail.com> <51AFA6DD.3000202@wwwdotorg.org> <CAPweEDz=hFxXW3XF9CSNZpEFSjayb5an1E8Xze1_uQcCZONVxg@mail.gmail.com> <1370469574.18839.33.camel@localhost> <CAPweEDxMpeJc-w=Yd7d2OT=UisRBp2rxf-MPMDUCOG3EyJz1GQ@mail.gmail.com> <CAKON4OxwyV2f_iTEb5RnP_azc7EsSxPdku_TY5WLWxN7USiY1Q@mail.gmail.com> <CAPweEDw1BabE0cmT5fxZ3Z9p9EH508M3Nzcqk2VcO0oz-qYsvg@mail.gmail.com> <1370475609.20454.44.camel@localhost> <CAPweEDwS3tR=wh-bZJb3vqR8fVQra=3XxDitowGRdH9c7WRfmQ@mail.gmail.com> <1370477958.20454.68.camel@localhost> <CAPweEDyPffcN9cNJ10ZHt+AZJHTRdU0LMfCGM_756uAbf+NEBQ@mail.gmail.com>
In-Reply-To: <CAPweEDyPffcN9cNJ10ZHt+AZJHTRdU0LMfCGM_756uAbf+NEBQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

luke.leighton wrote:
> On Thu, Jun 6, 2013 at 1:19 AM, Henrik Nordström
> <henrik@henriknordstrom.net> wrote:
>> tor 2013-06-06 klockan 00:54 +0100 skrev luke.leighton:
>>
>>> > Not really the case. Actually the opposite. DT have this as well, and
>>> > integrated in device probing. Allwinner need to hack every driver used
>>> > to add their gpio requests to have pinmuxing triggered.
>>>
>>>  augh.  ok.  solutions.  what are the solutions here?
>>
>> What I said before.
>
>   idea: hook into devicetree gpio functions to allow script-fex gpio
> functions to gain access in a separate module?  that sort of thing.
>
>> Go with DT for the kernel. There is no need for two configuration
>> mechanisms doing the same thing. Disguise it in fex form (and
>> translator) if too hard for people with a DOS editior to configure.
>
>   what methods for doing that.  i need proposals.  4 days on the clock.

4 days? WTF? since when did setting an ultimatum to the kernel
community work?


