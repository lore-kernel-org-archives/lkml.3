Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbaDKHvq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 03:51:46 -0400
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:15280 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbaDKHvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 03:51:43 -0400
X-IronPort-AV: E=Sophos;i="4.97,840,1389772800"; 
   d="scan'208";a="23769985"
Message-ID: <53479F0B.6070909@broadcom.com>
Date: Fri, 11 Apr 2014 09:51:39 +0200
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
CC: Takashi Iwai <tiwai@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felix Fietkau <nbd@openwrt.org>,
        "backports@vger.kernel.org" <backports@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: Bumping required kernels to 3.0 for Linux backports ?
References: <CAB=NE6VvyBKzEg=ErZzQMktY8eLytQ21JCPrOQbxvZ9m-nqHkw@mail.gmail.com> <53451077.2030102@openwrt.org> <CAB=NE6UUN4vQd3SpsvO5tcgaYq3YXQeE0KtZGki7p7OnR=J4RA@mail.gmail.com> <20140409191225.GA10560@kroah.com> <CAB=NE6VqY8yXoYuE0o01vq86imY8EtqLdkPa4bGMvR3bTaj5KQ@mail.gmail.com> <20140409202224.GA12953@kroah.com> <CAB=NE6XY5++p7hJQpQdwrFNUcGbUsKpC+oJiZQciXNduo+8j8A@mail.gmail.com> <20140409210613.GA14392@kroah.com> <s5heh15pr18.wl%tiwai@suse.de> <CAB=NE6VeNTFeGxKXpYunkU-W=JPLMpOnrehttvsqB+yXkdz5fg@mail.gmail.com> <5346CF27.3070406@broadcom.com> <CAB=NE6Wpa4gG14+XYVkT_=_t-cZXvO0FD_Q1T7tB1yiSmNBraw@mail.gmail.com>
In-Reply-To: <CAB=NE6Wpa4gG14+XYVkT_=_t-cZXvO0FD_Q1T7tB1yiSmNBraw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/14 20:56, Luis R. Rodriguez wrote:
> On Thu, Apr 10, 2014 at 10:04 AM, Arend van Spriel <arend@broadcom.com> wrote:
>> Ok, I guess my voice was cracking when I mentioned 2.6.38 as being used over
>> here. I am probably alone in that desert.
>
> I thought broadcom didn't use backports? If they do can you explain
> how? Also what drivers do you need enabled for your use case ?

That was 2 years ago when you asked me ;-) Since then I have been using 
it to backport the brcm80211 mainline drivers to 1) Android kernel, ie. 
3.4 kernel, and 2) Fedora 19 which is actually fixed to 3.11 kernel.

So we use backports these days for enabling brcm80211 drivers on various 
test equipment that uses older kernels.

Regards,
Arend

