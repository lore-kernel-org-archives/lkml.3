Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751720AbaCYDIN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 23:08:13 -0400
Received: from mail.lang.hm ([64.81.33.126]:55590 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972AbaCYDIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 23:08:11 -0400
Date: Mon, 24 Mar 2014 20:08:02 -0700 (PDT)
From: David Lang <david@lang.hm>
X-X-Sender: dlang@asgard.lang.hm
To: Matias Bjorling <m@bjorling.me>
cc: device-mapper development <dm-devel@redhat.com>, snitzer@redhat.com,
        agk@redhat.com, neilb@suse.de, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH RFC v1 00/01] dm-lightnvm introduction
In-Reply-To: <532C5930.7040107@bjorling.me>
Message-ID: <alpine.DEB.2.02.1403242004580.527@nftneq.ynat.uz>
References: <1395383538-18019-1-git-send-email-m@bjorling.me> <20140321090630.GA30044@debian> <532C5930.7040107@bjorling.me>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2014, Matias Bjorling wrote:

> On 03/21/2014 02:06 AM, Joe Thornber wrote:
>> Hi Matias,
>>
>> This looks really interesting and I'd love to get involved.  Do you
>> have any recommendations for what hardware I should pick up?
>
> Hi Joe,
>
> The most easily available platform is OpenSSD
> (http://www.openssd-project.org). It's a little old, but still very
> functional. When there's a good firmware implementation, I think it will
> be easier for the custom SSD vendor's to jump on board with their own
> firmware.

Is this something that would make sense to use for accessing the NAND flash 
that's being used on routers nowdays? Talking with the OpenWRT folks, they are 
having trouble supporting those devices because the flash may contain defects 
and squashfs doesn't work in such an environment. This appears to be the one 
remaining problem preventing a lot of new routers from working.

If this can work as a shim layer between the hardware and the filesystem for 
OpenWRT, you would gain a very large userbase rather quickly.

David Lang
