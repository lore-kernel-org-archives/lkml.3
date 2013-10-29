Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040Ab3J2Tq1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 15:46:27 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:36465 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751345Ab3J2TqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 15:46:25 -0400
X-Sasl-enc: QhaRnatL4u+e7QoJ42xl84uUW3itc2aH4F4r6QJN7GaE 1383075984
Message-ID: <5270108E.5040401@itwm.fraunhofer.de>
Date: Tue, 29 Oct 2013 20:46:22 +0100
From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Joseph Salisbury <joseph.salisbury@canonical.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC: hpa@zytor.com, JBottomley@Parallels.com,
        LKML <linux-kernel@vger.kernel.org>,
        Kamal Mostafa <kamal.mostafa@canonical.com>,
        linux-scsi@vger.kernel.org,
        Luis Henriques <luis.henriques@canonical.com>
Subject: Re: Subject:  [v3.8][v3.11][Regression] [SCSI] sd: Update WRITE SAME
 heuristics
References: <52700AD2.6000703@canonical.com>
In-Reply-To: <52700AD2.6000703@canonical.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Joseph,

On 10/29/2013 08:21 PM, Joseph Salisbury wrote:
> Hi Martin,
>
> A bug was opened against the Ubuntu kernel[0].  After a kernel bisect,
> it was found that reverting the following commit resolved this bug:
>
> commit 66c28f97120e8a621afd5aa7a31c4b85c547d33d
> Author: Martin K. Petersen <martin.petersen@oracle.com>
> Date:   Thu Jun 6 22:15:55 2013 -0400
>
>      [SCSI] sd: Update WRITE SAME heuristics
>
>
> The regression was introduced as of v3.11-rc1, but it also made it's way
> into the stable trees.
>
> I see that you are the author of this patch, so I wanted to run this by
> you.  I was thinking of requesting a revert for v3.12, but I wanted to
> get your feedback first.
>

James queued this up for 3.13

> http://git.kernel.org/cgit/linux/kernel/git/jejb/scsi.git/commit/?id=735e39e680256a13e7be3492acfb4d9721287a42

Maybe we should try to convince James to take it into 3.12?


Cheers,
Bernd
