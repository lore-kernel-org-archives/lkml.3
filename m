Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550Ab3J3T3q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 15:29:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38349 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698Ab3J3T3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 15:29:44 -0400
Message-ID: <52715DF5.9040100@canonical.com>
Date: Wed, 30 Oct 2013 15:28:53 -0400
From: Joseph Salisbury <joseph.salisbury@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC: hpa@zytor.com, JBottomley@Parallels.com,
        LKML <linux-kernel@vger.kernel.org>,
        Kamal Mostafa <kamal.mostafa@canonical.com>,
        linux-scsi@vger.kernel.org,
        Luis Henriques <luis.henriques@canonical.com>
Subject: Re: Subject:  [v3.8][v3.11][Regression] [SCSI] sd: Update WRITE SAME
 heuristics
References: <52700AD2.6000703@canonical.com> <5270108E.5040401@itwm.fraunhofer.de>
In-Reply-To: <5270108E.5040401@itwm.fraunhofer.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2013 03:46 PM, Bernd Schubert wrote:
> Hello Joseph,
>
> On 10/29/2013 08:21 PM, Joseph Salisbury wrote:
>> Hi Martin,
>>
>> A bug was opened against the Ubuntu kernel[0].  After a kernel bisect,
>> it was found that reverting the following commit resolved this bug:
>>
>> commit 66c28f97120e8a621afd5aa7a31c4b85c547d33d
>> Author: Martin K. Petersen <martin.petersen@oracle.com>
>> Date:   Thu Jun 6 22:15:55 2013 -0400
>>
>>      [SCSI] sd: Update WRITE SAME heuristics
>>
>>
>> The regression was introduced as of v3.11-rc1, but it also made it's way
>> into the stable trees.
>>
>> I see that you are the author of this patch, so I wanted to run this by
>> you.  I was thinking of requesting a revert for v3.12, but I wanted to
>> get your feedback first.
>>
>
> James queued this up for 3.13
>
>> http://git.kernel.org/cgit/linux/kernel/git/jejb/scsi.git/commit/?id=735e39e680256a13e7be3492acfb4d9721287a42
>>
>
> Maybe we should try to convince James to take it into 3.12?
>
>
> Cheers,
> Bernd
Hi Bernd,

The bug reporter confirms that your patch fixes the bug.  Any chance
this patch can make it into 3.12?

Thanks,

Joe
