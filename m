Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860AbaEBJvv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 05:51:51 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:42473 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbaEBJvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 05:51:50 -0400
MIME-Version: 1.0
X-Originating-IP: [60.248.88.209]
In-Reply-To: <1398876964.2182.13.camel@dabdike.int.hansenpartnership.com>
References: <1398850855.1769.11.camel@localhost>
	<1398876964.2182.13.camel@dabdike.int.hansenpartnership.com>
Date: Fri, 2 May 2014 17:51:48 +0800
Message-ID: <CAKiknE8ZapUdnygsAVB8rwv_HwnT-+diXVVKaNby8YCiHzYK4g@mail.gmail.com>
Subject: Re: [PATCH v1.0 1/11] arcmsr: Revise interrupt service routine relate function
From: =?UTF-8?B?6buD5riF6ZqG?= <ching2048@areca.com.tw>
To: James Bottomley <jbottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>,
        "thenzl@redhat.com" <thenzl@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

Indeed, it makes you confusion that I mistake typing the subject.
It should be [PATCH v1.0 1/16] , but not [PATCH v1.0 1/11].
Why I use v1.0 other than v1.4? Changing from 11 patches to 16 patches.
Because I spend a long time to simplify each patch, so patch number is increase.
It is easier to review.

I am so sorry for late to response that make you are inconvenient.
>From now on, I will response quickly.

Thanks for your advice.

2014-05-01 0:56 GMT+08:00 James Bottomley <jbottomley@parallels.com>:
> On Wed, 2014-04-30 at 17:40 +0800, ching wrote:
>> From: Ching<ching2048@areca.com.tw>
>>
>> Rewrite interrupt service routine relate function to fix command
>> timeout on controller very heavy loading.
>
> OK, so I think you've confused us a bit.  This looks to be an update of
> your previous v1.4 patch set, yet it's now called v1.0?
>
> Could you please include a cover letter as patch 0/x like you see
> everyone else doing on the list?  In this cover letter can you tell us
> what the disposition of the previous feedback is and what other changes
> have you done? You didn't reply to any of the comments, have have you
> fixed them?  It's very dispiriting to review 11 patches, give feedback
> and not hear anything ... and then have to review an even longer set of
> patches just to see if anything was done about your previous comments.
>
> The less interactive you are with reviews, the less chance there is that
> people will review updates ... without external reviewers, you go on a
> very long backlog of things I have to review before the patches get in.
>
> James
>
