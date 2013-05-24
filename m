Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759993Ab3EXHgM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 03:36:12 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:37881 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756887Ab3EXHgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 03:36:11 -0400
Message-ID: <1369380965.1945.10.camel@dabdike>
Subject: Re: [PATCH v3 part1 1/4] sg_io: pass request_queue to
 blk_verify_command
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, tj@kernel.org, stable@gnu.org,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Date: Fri, 24 May 2013 11:36:05 +0400
In-Reply-To: <1369317503-4095-2-git-send-email-pbonzini@redhat.com>
References: <1369317503-4095-1-git-send-email-pbonzini@redhat.com>
	 <1369317503-4095-2-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-05-23 at 15:58 +0200, Paolo Bonzini wrote:
> Adjust the blk_verify_command function to let it look at per-queue
> data.  This will be done in the next patch.

This is not a bug fix.  This is an enabler for your complex and to my
mind dubious rework of the SG_IO command filter.  I'm running out of
ways to say please don't mix bug fixes with features, because this
redesignating of the original patch set as part 1 and parts 2,3 doesn't
satisfy the requirement.

Does anyone in the real world actually care about this bug?  because if
not perhaps we can just remove the confusion and consider this as a
feature set.  If there's someone who actually cares, please lets just do
the bug fix first and argue about the feature later.

James


