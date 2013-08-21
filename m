Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088Ab3HUO15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 10:27:57 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:2638 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534Ab3HUO14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 10:27:56 -0400
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
Message-ID: <5214CE5F.5010009@broadcom.com>
Date: Wed, 21 Aug 2013 16:27:43 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US;
 rv:1.9.2.24) Gecko/20111103 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: "Josh Boyer" <jwboyer@fedoraproject.org>
cc: "Felix Fietkau" <nbd@openwrt.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Tom Gundersen" <teg@jklm.no>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Linux Wireless List" <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [REGRESSION] 3.10.{6,7} crashes on network activity
References: <CAG-2HqUXQeq=30EpGWmn6tkC=CP1W+=UZCVPTYhhE0WyU_C4nw@mail.gmail.com>
 <20130820000336.GA15548@kroah.com>
 <CAG-2HqUkxvtJNGx0UbZVfaBNvSY-OU+=anSSnroS3AfSR9H0SA@mail.gmail.com>
 <20130820002822.GA18023@kroah.com> <5212F6E8.3090107@openwrt.org>
 <52132589.5000306@broadcom.com>
 <CA+5PVA7gvnfX2vnpxEGCgaAYXRvA=SME4SYZpTESqLsMkgSu=g@mail.gmail.com>
 <52147FD2.9020401@broadcom.com>
 <CA+5PVA5Wi=Xjrsb_Rh53A4NkWHe3h-gfs89dO6Zfb+6uh+G=dQ@mail.gmail.com>
In-Reply-To: <CA+5PVA5Wi=Xjrsb_Rh53A4NkWHe3h-gfs89dO6Zfb+6uh+G=dQ@mail.gmail.com>
X-WSS-ID: 7E0A12F331W86468204-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/13 14:38, Josh Boyer wrote:
> On Wed, Aug 21, 2013 at 4:52 AM, Arend van Spriel<arend@broadcom.com>  wrote:
>>>> Hi Felix,
>>>>
>>>> I have been diving into root causing why brcmsmac can not handle cck
>>>> fallback rates, because it should. Maybe it is better to flag no cck
>>>> support
>>>> and only change brcmsmac.
>>>
>>>
>>> We have a number of users hitting this in Fedora 18 and 19 now.  We're
>>> tracking it with https://bugzilla.redhat.com/show_bug.cgi?id=998080
>>> and I'm sure we can find people to test easily.
>>
>>
>> There is already another one (possibly) dealing with the same issue:
>>
>> https://bugzilla.redhat.com/show_bug.cgi?id=989269
>>
>> One of them should probably be flagged as duplicate.
>>
>>
>>> If you have a patch disabling cck in brcmsmac, I'd be happy to build a
>>> kernel for people.  If that's going to be some time coming, perhaps
>>> it's better to grab Felix's patch on a temporary basis?
>>
>>
>> I think it is better to grab Felix's patch because as we both observed there
>> is stuff missing in brcmsmac to deal with CCK rates and A-MPDU packet
>> aggregation.
>
> OK, thanks.
>
> Felix, are you going to send that upstream?

It already has been sent: 
http://mid.gmane.org/1377020634-27064-1-git-send-email-nbd@openwrt.org

Johannes has submitted it to John so it is getting there soon(ish).

> josh

Regards,
Arend



