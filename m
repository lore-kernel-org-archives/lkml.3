Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759588Ab3KMQwp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 11:52:45 -0500
Received: from multi.imgtec.com ([194.200.65.239]:32448 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757003Ab3KMQwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 11:52:41 -0500
Message-ID: <5283AE49.2080503@imgtec.com>
Date: Wed, 13 Nov 2013 10:52:25 -0600
From: "Steven J. Hill" <Steven.Hill@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Aaro Koskinen <aaro.koskinen@iki.fi>
CC: LMOL <linux-mips@linux-mips.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Release of Linux MTI-3.10-LTS kernel.
References: <528246BA.10607@imgtec.com> <20131112210234.GB30010@blackmetal.musicnaut.iki.fi>
In-Reply-To: <20131112210234.GB30010@blackmetal.musicnaut.iki.fi>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.159.180]
X-SEF-Processed: 7_3_0_01192__2013_11_13_16_52_32
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2013 03:02 PM, Aaro Koskinen wrote:
> Hi,
>
> On Tue, Nov 12, 2013 at 09:18:18AM -0600, Steven J. Hill wrote:
>> Imagination Technologies is pleased to announce the release of its
>> 3.10 LTS (Long-Term Support) MIPS kernel. The changelog below is
>> based off the stable Linux 3.10.14 release done by Greg
>> Kroah-Hartman in commit
>> 8c15abc94c737f9120d3d4a550abbcbb9be121f6 back on October 1st. The
>> code repository is hosted at the Linux/MIPS project GIT:
>>
>> http://git.linux-mips.org/?p=linux-mti.git;a=summary
>>
>> We look forward to any comments or feedback.
>
> Why multiple MIPS stable trees? There's already also
> http://git.linux-mips.org/?p=ralf/linux.git;a=shortlog;h=refs/heads/linux-3.10-stable?
>
We track 'linux-stable' because the ones on LMO have too much lag.

> Also 3.10.14 sounds quite old. Are you sure you are not missing any
> important fixes?
>
We ran this kernel on 20 different board/core combinations. They ran our 
stress test suite continuously for over a week at 100% load with no 
failures. We have high confidence in this particular release. There are 
always bugs, so your question is somewhat ridiculous. Regarding age, go 
ask the Android team why the latest KitKat release is running a 3.4.0 
kernel and not the latest and greatest.

