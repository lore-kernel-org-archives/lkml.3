Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647Ab3C2SGg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 14:06:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30813 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755884Ab3C2SGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 14:06:34 -0400
Date: Fri, 29 Mar 2013 14:04:55 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@surriel.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        hhuang@redhat.com, "Low, Jason" <jason.low2@hp.com>,
        Michel Lespinasse <walken@google.com>,
        Larry Woodman <lwoodman@redhat.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: Re: ipc,sem: sysv semaphore scalability
Message-ID: <20130329180455.GA22395@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rik van Riel <riel@surriel.com>,
	Davidlohr Bueso <davidlohr.bueso@hp.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	hhuang@redhat.com, "Low, Jason" <jason.low2@hp.com>,
	Michel Lespinasse <walken@google.com>,
	Larry Woodman <lwoodman@redhat.com>,
	"Vinod, Chegu" <chegu_vinod@hp.com>,
	Peter Hurley <peter@hurleysoftware.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
 <20130321141058.76e028e492f98f6ee6e60353@linux-foundation.org>
 <20130326192852.GA25899@redhat.com>
 <20130326124309.077e21a9f59aaa3f3355e09b@linux-foundation.org>
 <20130329161746.GA8391@redhat.com>
 <CA+55aFxbs0=fpFA+rAW-jOD9C8muRfA0otfJ13yhhLMSg7H8bw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxbs0=fpFA+rAW-jOD9C8muRfA0otfJ13yhhLMSg7H8bw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 29, 2013 at 11:00:27AM -0700, Linus Torvalds wrote:
 > On Fri, Mar 29, 2013 at 9:17 AM, Dave Jones <davej@redhat.com> wrote:
 > >
 > > Now that I have that reverted, I'm not seeing msgrcv traces any more, but
 > > I've started seeing this..
 > >
 > > general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
 > >
 > > Looks like seg was already kfree'd.
 > 
 > Just to clarify: is this you testing -mm that has Davidlohr's and
 > Rik's scalability patches? Or mainline?

mainline. Your current tree.

	Dave
