Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759849Ab3BHJyF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 04:54:05 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:35794 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab3BHJyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 04:54:03 -0500
Message-ID: <5114CB24.2070509@ahsoftware.de>
Date: Fri, 08 Feb 2013 10:53:40 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Bernie Thompson <bernie@plugable.com>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/3 v2] fb: udlfb: fix hang at disconnect
References: <51071E21.9030008@ahsoftware.de> <5107A5ED.7020009@ahsoftware.de> <5107AE4F.9000809@ahsoftware.de> <5107F014.4030704@ahsoftware.de> <5108329E.2050802@ahsoftware.de> <20130204011413.GA6413@kroah.com> <510FA409.2080201@ahsoftware.de> <51100930.6080405@ahsoftware.de> <20130204192514.GA32318@kroah.com> <5110AFEC.8020406@ahsoftware.de> <20130205172245.GA1426@kroah.com> <5111431D.8070906@ahsoftware.de> <CAPM=9tzNeQTXAmvZZ1RCmn6uTYHvweYKKnSPYAh7QYRGNMgeUw@mail.gmail.com>
In-Reply-To: <CAPM=9tzNeQTXAmvZZ1RCmn6uTYHvweYKKnSPYAh7QYRGNMgeUw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 08.02.2013 05:07, schrieb Dave Airlie:
>>
>> But I've just switched to udl (instead of udlfb) and will see if I can fix
>> the bugs there to make it usable as a console. udl is a rewrite of udlfb
>> with some additional features (e.g. drm), so hopefully fixing the remaining
>> problems there will require less work.
>
> I may have fixed the major udl problem with being a console, patch was
> posted to dri-devel yesterday, and I've pushed it into -next.

Thanks a lot. I will check it.

Regards,

Alexander

