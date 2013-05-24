Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081Ab3EXHnu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 03:43:50 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:46355 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759496Ab3EXHns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 03:43:48 -0400
Message-ID: <519F1A28.6080303@redhat.com>
Date: Fri, 24 May 2013 09:43:36 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: linux-kernel@vger.kernel.org, tj@kernel.org,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v3 part1 1/4] sg_io: pass request_queue to blk_verify_command
References: <1369317503-4095-1-git-send-email-pbonzini@redhat.com>  <1369317503-4095-2-git-send-email-pbonzini@redhat.com> <1369380965.1945.10.camel@dabdike>
In-Reply-To: <1369380965.1945.10.camel@dabdike>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 24/05/2013 09:36, James Bottomley ha scritto:
> On Thu, 2013-05-23 at 15:58 +0200, Paolo Bonzini wrote:
>> Adjust the blk_verify_command function to let it look at per-queue
>> data.  This will be done in the next patch.
> 
> This is not a bug fix.  This is an enabler for your complex and to my
> mind dubious rework of the SG_IO command filter.  I'm running out of
> ways to say please don't mix bug fixes with features, because this
> redesignating of the original patch set as part 1 and parts 2,3 doesn't
> satisfy the requirement.

I made it part 1/2/3 because parts 2/3 depend on part 1.  It makes
dependency tracking easier, at least in my mind.

If you have another solution that does not require passing request_queue
to blk_verify_command, I'm all ears.

> Does anyone in the real world actually care about this bug?

Yes, or I would move on and not waste so much time on this.

Paolo

> because if
> not perhaps we can just remove the confusion and consider this as a
> feature set.  If there's someone who actually cares, please lets just do
> the bug fix first and argue about the feature later.
> 
> James
> 
> 

