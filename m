Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030948AbaLLRKL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 12:10:11 -0500
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:32922 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030303AbaLLRKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 12:10:09 -0500
X-Greylist: delayed 554 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Dec 2014 12:10:09 EST
Message-ID: <548B1F3C.8000600@ovro.caltech.edu>
Date: Fri, 12 Dec 2014 09:00:44 -0800
From: David Hawkins <dwh@ovro.caltech.edu>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, Ira Snyder <ira.snyder@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, iws@ovro.caltech.edu,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] carma-fpga: remove videobuf dependency
References: <1416752630-47360-1-git-send-email-hverkuil@xs4all.nl> <CAH1ssNCnfdzCx5DhVW1=Kd8_J0wGaQ2yhbmUoZLG29g+12qV+g@mail.gmail.com> <548AF563.3050204@xs4all.nl>
In-Reply-To: <548AF563.3050204@xs4all.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (ovro.ovro.caltech.edu [0.0.0.0]); Fri, 12 Dec 2014 09:00:53 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans!

>> On Nov 23, 2014 6:31 AM, "Hans Verkuil" <hverkuil@xs4all.nl
>> <mailto:hverkuil@xs4all.nl>> wrote:
>>>
>>> While checking which drivers were still abusing internal videobuf
>>> API functions I came across these carma fpga misc drivers. These
>>> drivers have absolutely nothing to do with videobuf or the media
>>> subsystem.
>>>
>>> Drivers shouldn't use those low-level functions in the first
>>> place, and in fact in the long run the videobuf API will be
>>> removed altogether.
>>>
>>> So remove the videobuf dependency from these two drivers.
>>>
>>> This has been compile tested (and that clearly hasn't been done
>>> for carma-fpga-program.c recently).
>>>
>>> Greg, is this something you want to take as misc driver
>>> maintainer? That makes more sense than going through the media
>>> tree.
>>>
>>> The first patch should probably go to 3.18.
>>>
>>> I have no idea if anyone can test this with actual hardware. Ira,
>>> is that something you can do?
>>
>> Hi Hans. My colleague Dave Hawkins (CC'd) is in charge of this
>> hardware now. He can help to get this patch tested.
>
> Any updates on this?

Sorry, I was hoping to get around to setting up a build system
for this board and testing it, but I have not had a chance to.

Go ahead and apply any changes you need, and I'll try to get a
hardware test done before Christmas :)

Thanks!

Cheers,
Dave

