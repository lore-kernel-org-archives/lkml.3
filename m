Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934008Ab3CVQXd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 12:23:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28655 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933715Ab3CVQXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 12:23:31 -0400
Date: Fri, 22 Mar 2013 12:23:26 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [CFT] Re: VFS deadlock ?
Message-ID: <20130322162326.GA2543@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>
References: <CA+55aFyWNkOnrQ41xCAU8q5sVXdq1-u2P8n+quLY50OdiFo3Zw@mail.gmail.com>
 <20130322001257.GH21522@ZenIV.linux.org.uk>
 <CA+55aFz5Ce7h2ja0m++tENXuG-1d346VNu9N=ZKy2UfojaSf0g@mail.gmail.com>
 <20130322012208.GJ21522@ZenIV.linux.org.uk>
 <CA+55aFzPD08kJi=x8wLBi5FAjr1TqSGXWbv5KXy5Ymm0PJL0wA@mail.gmail.com>
 <20130322014037.GK21522@ZenIV.linux.org.uk>
 <20130322043715.GL21522@ZenIV.linux.org.uk>
 <CA+55aFzUobqDR0RSh8t18m32BdTvm4k7j2PCseXpFVCH_gR=Fw@mail.gmail.com>
 <20130322051817.GM21522@ZenIV.linux.org.uk>
 <CA+55aFzbV81KQh_f0=wti9=_6=PXu37z0+NJymhDvzv13GgpuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzbV81KQh_f0=wti9=_6=PXu37z0+NJymhDvzv13GgpuA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 10:33:27PM -0700, Linus Torvalds wrote:

 > Ok, that's kind of ugly, but shouldn't be a correctness issue. It
 > should still work - just cycle through inodes quite aggressivelydue to
 > no longer re-using them - so I suspect Dave could test it (with the
 > extra line removed I pointed out just a moment ago).

Been running a few hours now without incident.
Of course, proving absense of a bug is always fun when fuzzing, as it
may have just not run long enough yet.. though I was hitting it pretty
quickly last night.

	Dave

 
