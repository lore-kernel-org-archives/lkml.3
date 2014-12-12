Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967786AbaLLOCX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 09:02:23 -0500
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:44973 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966281AbaLLOCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 09:02:21 -0500
Message-ID: <548AF563.3050204@xs4all.nl>
Date: Fri, 12 Dec 2014 15:02:11 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Ira Snyder <ira.snyder@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, iws@ovro.caltech.edu,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        dwh@ovro.caltech.edu
Subject: Re: [PATCH 0/3] carma-fpga: remove videobuf dependency
References: <1416752630-47360-1-git-send-email-hverkuil@xs4all.nl> <CAH1ssNCnfdzCx5DhVW1=Kd8_J0wGaQ2yhbmUoZLG29g+12qV+g@mail.gmail.com>
In-Reply-To: <CAH1ssNCnfdzCx5DhVW1=Kd8_J0wGaQ2yhbmUoZLG29g+12qV+g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

On 11/24/2014 06:45 PM, Ira Snyder wrote:
> 
> On Nov 23, 2014 6:31 AM, "Hans Verkuil" <hverkuil@xs4all.nl <mailto:hverkuil@xs4all.nl>> wrote:
>>
>> While checking which drivers were still abusing internal videobuf API
>> functions I came across these carma fpga misc drivers. These drivers
>> have absolutely nothing to do with videobuf or the media subsystem.
>>
>> Drivers shouldn't use those low-level functions in the first place,
>> and in fact in the long run the videobuf API will be removed altogether.
>>
>> So remove the videobuf dependency from these two drivers.
>>
>> This has been compile tested (and that clearly hasn't been done for
>> carma-fpga-program.c recently).
>>
>> Greg, is this something you want to take as misc driver maintainer?
>> That makes more sense than going through the media tree.
>>
>> The first patch should probably go to 3.18.
>>
>> I have no idea if anyone can test this with actual hardware. Ira, is
>> that something you can do?
>>
> 
> Hi Hans. My colleague Dave Hawkins (CC'd) is in charge of this hardware now. He can help to get this patch tested.

Any updates on this?

Regards,

	Hans
