Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471Ab3LMKcQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 05:32:16 -0500
Received: from mout.web.de ([212.227.17.12]:60619 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752286Ab3LMKcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 05:32:14 -0500
Message-ID: <52AAE22A.30701@web.de>
Date: Fri, 13 Dec 2013 11:32:10 +0100
From: Emanuel Krenz <emanuelkrenz@web.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>, Greg KH <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: hid-multitouch: add support for SiS panel in LG
 23ET83V
References: <52AA2810.2010807@web.de> <20131213020542.GE13333@kroah.com> <alpine.LRH.2.00.1312131036520.7125@twin.jikos.cz>
In-Reply-To: <alpine.LRH.2.00.1312131036520.7125@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:87gB3J6XBW0XpOPNYcTEkPVGAJltcWRf97lk+SgQiasfeJYBm5J
 lY7mNE9X6kf7/pUzPIivFeZPo5xaNmchjNAfqYD8Lgd1ywKJci74tLd8kPwI3DOu2O78FQl
 OoxFzmklpR0vDnCxtjWxW11bqjSMxUcGEY8pX8kfKXYTT/9T/fTxW0m2Ip3V01WeX+aY+PY
 NLAAwoTdED+R6uwxOQQAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 13.12.2013 10:39, schrieb Jiri Kosina:
> On Thu, 12 Dec 2013, Greg KH wrote:
>
>>> 3.12.5-stable patch
>>>
>>> --------------------
>>> From: Emanuel Krenz <emanuelkrenz@web.de>
>>>
>>> Add support for SiS multitouch panel in the touch monitor LG 23ET83V.
>>>
>>> Signed-off-by: Emanuel Krenz <emanuelkrenz@web.de>
>>> Signed-off-by: Forest Bond <forest.bond@rapidrollout.com>
>>> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> I signed off on this?  What is the git commit id of the patch in Linus's
>> tree?
> I haven't either, and I don't think I have ever seen this patch (it's
> definitely neither in Linus' nor my tree).
>
> Emanuel, what is going on here, please? Is it that you authored this patch
> yourself, and would like to have it included in Linus' tree (only then it
> can go to -stable)?
>
> If so, please remove all Signoffs of people who haven't provided it to
> you, and resubmit it to maintainer (./scripts/get_maintainer.pl will tell
> you who are proper recepients of this patch).
>
> Thanks,
>
Hello,
I'm sorry, guys. I thought I have to add those "Signed-off-by" lines to 
mention, where I got the ideas for this patch from.
It was actually this patch: https://lkml.org/lkml/2013/12/2/647
That was obviously a mistake, please forgive me.
As I mentioned, this was my first submitted patch, I was just so excited 
that I might help developing.

Thank you, Jiri, for telling me, to remove this "Signed-off-by" lines 
and resubmit the patch after using get_maintainer.pl.
Now I actually got your name as the maintainer of HID CORE LAYER. So 
i'll send it to you again without those lines, i hope it's correct now.

Thanks, guys, for all your work and help!

