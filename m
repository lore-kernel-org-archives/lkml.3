Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655Ab3AQPCQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 10:02:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39094 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756514Ab3AQPCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 10:02:15 -0500
Date: Thu, 17 Jan 2013 10:02:02 -0500
From: Dave Jones <davej@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Josh Boyer <jwboyer@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
        dhowells@redhat.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, mingo@redhat.com
Subject: Re: [PATCH] MODSIGN: Add TAINT_NOKEY_MODULE
Message-ID: <20130117150202.GB32586@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Josh Boyer <jwboyer@redhat.com>,
	"Frank Ch. Eigler" <fche@redhat.com>, dhowells@redhat.com,
	linux-kernel@vger.kernel.org, peterz@infradead.org,
	mingo@redhat.com
References: <20130104191205.GD27554@hansolo.jdub.homelinux.org>
 <87bod14x44.fsf@rustcorp.com.au>
 <20130107145832.GA12363@hansolo.jdub.homelinux.org>
 <20130115190911.GA6964@hansolo.jdub.homelinux.org>
 <87y5ftyf51.fsf@rustcorp.com.au>
 <20130116193724.GF6964@hansolo.jdub.homelinux.org>
 <87pq14y6bs.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pq14y6bs.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 11:27:27AM +1030, Rusty Russell wrote:
 
 > taint: add explicit flag to show whether lock dep is still OK.
 > 
 > Fix up all callers as they were before, with make one change: an
 > unsigned module taints the kernel, but doesn't turn off lockdep.
 > 
 > Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
 
This made my brain itch a little until I got to the bottom of the
patch and saw the new definition of add_taint.  Perhaps instead of
false/true, we have LOCKDEP_LIVES/LOCKDEP_DIES or similar defines
to make it clearer what's actually happening without having to
go read the function ?

 > + * If something bad has gone wrong, you'll want @lockdebug_ok = false, but for
 > + * some notewortht-but-not-corrupting cases, it can be set to true.
 > + */

'noteworthy'

	Dave

