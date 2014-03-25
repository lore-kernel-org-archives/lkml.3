Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554AbaCYD4j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 23:56:39 -0400
Received: from mail-yh0-f42.google.com ([209.85.213.42]:34995 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbaCYD4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 23:56:37 -0400
Message-ID: <5330FE66.4080908@bjorling.me>
Date: Mon, 24 Mar 2014 20:56:22 -0700
From: Matias Bjorling <m@bjorling.me>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: David Lang <david@lang.hm>
CC: device-mapper development <dm-devel@redhat.com>, snitzer@redhat.com,
        agk@redhat.com, neilb@suse.de, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH RFC v1 00/01] dm-lightnvm introduction
References: <1395383538-18019-1-git-send-email-m@bjorling.me> <20140321090630.GA30044@debian> <532C5930.7040107@bjorling.me> <alpine.DEB.2.02.1403242004580.527@nftneq.ynat.uz>
In-Reply-To: <alpine.DEB.2.02.1403242004580.527@nftneq.ynat.uz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2014 08:08 PM, David Lang wrote:
> On Fri, 21 Mar 2014, Matias Bjorling wrote:
> 
>> On 03/21/2014 02:06 AM, Joe Thornber wrote:
>>> Hi Matias,
>>>
>>> This looks really interesting and I'd love to get involved.  Do you
>>> have any recommendations for what hardware I should pick up?
>>
>> Hi Joe,
>>
>> The most easily available platform is OpenSSD
>> (http://www.openssd-project.org). It's a little old, but still very
>> functional. When there's a good firmware implementation, I think it will
>> be easier for the custom SSD vendor's to jump on board with their own
>> firmware.
> 
> Is this something that would make sense to use for accessing the NAND
> flash that's being used on routers nowdays? Talking with the OpenWRT
> folks, they are having trouble supporting those devices because the
> flash may contain defects and squashfs doesn't work in such an
> environment. This appears to be the one remaining problem preventing a
> lot of new routers from working.
> 
> If this can work as a shim layer between the hardware and the filesystem
> for OpenWRT, you would gain a very large userbase rather quickly.

It's possible and would make sense. However, I'm not sure that its the
best choice.

>From what I can see, OpenWRT routers expose their flash through mtd.
Couldn't UBIFS be a better choice for this, instead of squashfs?

> 
> David Lang

