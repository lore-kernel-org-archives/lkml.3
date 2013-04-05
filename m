Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161786Ab3DEHZY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 03:25:24 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:1323 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161198Ab3DEHZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 03:25:22 -0400
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
Message-ID: <515E7C5B.2000408@broadcom.com>
Date: Fri, 5 Apr 2013 09:25:15 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308
 Thunderbird/17.0.4
MIME-Version: 1.0
To: "Randy Dunlap" <rdunlap@infradead.org>
cc: "Julian Calaby" <julian.calaby@gmail.com>,
        "Wang YanQing" <udknight@gmail.com>,
        "Johannes Berg" <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lib80211: make lib80211 can be enabled
 independently
References: <20130404160130.GA2577@udknight>
 <CAGRGNgXj7mSF0Fgyjek4Xcc34N26WHtt4HMmHk7DOopaEPrYFw@mail.gmail.com>
 <515E4CB7.6020405@infradead.org>
In-Reply-To: <515E4CB7.6020405@infradead.org>
X-WSS-ID: 7D40A4D83A08957691-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2013 06:01 AM, Randy Dunlap wrote:
> On 04/04/13 16:51, Julian Calaby wrote:
>> Hi Wang,
>>
>> On Fri, Apr 5, 2013 at 3:01 AM, Wang YanQing <udknight@gmail.com> wrote:
>>>
>>> Current we can only enable lib80211 by enable a driver
>>> in tree use it which will select it, but some out tree's
>>> drivers also use it, so I think it has sense to make lib80211
>>> can be enabled independently.
>>
>> Just as a bit of explanation for Johannes' NACK:
>>
>> 1. The only reason lib80211 still exists is because a couple of
>> in-tree drivers still use it. If this weren't the case, the code would
>> have been removed a long time ago as it's been completely replaced by
>> mac80211 and cfg80211. All modern drivers _must_ use mac80211 or
>> cfg80211 without exception.
>> 2. In general, there is no official in-kernel support for
>> out-of-kernel drivers, regardless of quality, status or importance.
>> 3. I believe that the in-tree brcmsmac driver already supports the
>> Broadcom card you reference.
>
>
> 3b.  If 3. is not correct, someone should endeavor to merge this
> out-of-tree driver into the kernel tree.

Actually, it is correct and brcmsmac and the out-of-tree wl driver are 
coming from the same code base although you should not compare the two 
these days.

Gr. AvS


