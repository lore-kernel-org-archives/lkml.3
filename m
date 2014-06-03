Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933068AbaFCPyX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 11:54:23 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:41109 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932308AbaFCPyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 11:54:22 -0400
Date: Tue, 3 Jun 2014 08:54:15 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Dave Chinner <david@fromorbit.com>, Steven Rostedt <rostedt@goodmis.org>,
        josh@joshtriplett.org, Joe Perches <joe@perches.com>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH RFC 1/2] MAINTAINERS: Add "R:" designated-reviewers tag
Message-ID: <20140603155415.GQ22231@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1401734669.7323.20.camel@joe-AO725>
 <20140602190951.GA13648@cloud>
 <1401736666.7323.25.camel@joe-AO725>
 <20140602231949.GV14410@dastard>
 <20140602235915.GB14801@cloud>
 <20140603011125.GW14410@dastard>
 <20140602213045.26219ddb@gandalf.local.home>
 <20140603071654.GC14410@dastard>
 <2024454617.25896.1401801863011.JavaMail.zimbra@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2024454617.25896.1401801863011.JavaMail.zimbra@efficios.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060315-0928-0000-0000-0000026161FD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 01:24:23PM +0000, Mathieu Desnoyers wrote:
> ----- Original Message -----
> > From: "Dave Chinner" <david@fromorbit.com>
> > To: "Steven Rostedt" <rostedt@goodmis.org>
> > Cc: josh@joshtriplett.org, "Joe Perches" <joe@perches.com>, paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
> > mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org, "mathieu desnoyers"
> > <mathieu.desnoyers@efficios.com>, niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org, dhowells@redhat.com,
> > edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com, sbw@mit.edu
> > Sent: Tuesday, June 3, 2014 3:16:54 AM
> > Subject: Re: [PATCH RFC 1/2] MAINTAINERS: Add "R:" designated-reviewers tag
> > 
> > On Mon, Jun 02, 2014 at 09:30:45PM -0400, Steven Rostedt wrote:
> > > On Tue, 3 Jun 2014 11:11:25 +1000
> > > Dave Chinner <david@fromorbit.com> wrote:
> > > 
> > > 
> > > > You've ignored the (c).(2) "free of known issues" criteria there.
> > > > You cannot say a patch is free of issues if you haven't applied,
> > > > compiled and tested it.
> > > > 
> > > > > We should not, for instance, prevent someone from providing a
> > > > > Reviewed-by (as opposed to an Acked-by) for a driver whose hardware few
> > > > > people actually have.  There's significant value in code review even
> > > > > without the ability to test.
> > > > 
> > > > I don't disagree with you that there's value in code review, but
> > > > that's not the only part of what "reviewed-by" means.
> > > > 
> > > > You can test that the code is free of known issues without reviewing
> > > > it (i.e. tested-by). You can read the code and note that you can't
> > > > see any technical issues without testing it (Acked-by).
> > > 
> > > Unless you run every test imaginable on all existing hardware, you are
> > > not stating that it is free of known issues. I say your logic is flawed
> > > right there.
> > 
> > If you take it to an extremes. Think about what you can test in 15
> > minutes. Or for larger patchsets, how long it takes you to read the
> > patchset?
> > 
> > IMO, every reviewer has their own developement environment and they
> > should be at least testing that the change they are reviewing
> > doesn't cause problems in that environment, just like they do for
> > their own code before they post it for review.
> > 
> > Code being reviewed should pass the same testing bar that the
> > developer uses for code they write and send for review. A maintainer
> > quickly learns whose test environments are up to scratch or not. :/
> > 
> > > > But you can't say that is it both free of techical and known
> > > > issues without both reading the code and testing it (Reviewed-by).
> > > 
> > > I disagree. Testing only tests what you run. It's useless otherwise.
> > > Most code I review, and find bugs for in that review, will not be
> > > caught by tests unless you ran it on a 1024 CPU box for a week.
> > > 
> > > I value looking hard at code much more than booting it and running some
> > > insignificant micro test.
> > 
> > Running "insignficant micro tests" is exactly that - insignificant -
> > and it's not a robust code review if that is all that is done.
> > Runing *regression tests*, OTOH....
> > 
> > I know from experience that a "quick" 15 minute run on xfstests on a
> > ramdisk will catch 99% of typical problems a filesystem patch might
> > introduce. Code coverage reporting (done recently by RH QE
> > engineers) tells me that this covers between 50-70% of the
> > filesystem, VFS and MM subsystems (numbers vary with fs being
> > tested), and so that's a pretty good, fast smoke test that I can run
> > on any patch or patchset that is sent for review.
> > 
> > Any significant patch set requires longer to read and digest than a
> > full xfstests run across all my test machines (about 80 minutes for
> > a single mkfs/mount option configuration). So by the time I've
> > actually read the code and commented on it, it's been through a full
> > test cycle and it's pretty clear if there are problems or not..
> > 
> > And so when I say "reviewed-by" I'm pretty certain that there aren't
> > any known issues.  Sure, it's not going to catch the "ran it on a
> > 1024 CPU box for a week" type of bug, but that's the repsonsibility
> > of the bug reporter to give you a "tested-by" for that specific
> > problem.
> > 
> > And really, that points out *exactly* the how "reviewed-by" is a far
> > more onerous than "tested-by". Tested-by only means the patch fixes
> > the *specific problem* that was reported.  Reviewed-by means that,
> > as far as the reviewer can determine, it doesn't cause regressions
> > or other problems. It may or may not imply "tested-by" depending on
> > the nature of the bug being fixed, but it certainly implies "no
> > obvious regressions".  They are two very different meanings, and
> > reviewed-by has a much, much wider scope than "tested-by".
> > 
> > > > And, yes, this is the definition we've been using for "reviewed-by"
> > > > for XFS code since, well, years before the "reviewed-by" tag even
> > > > existed...
> > > 
> > > Fine, just like all else. That is up to the maintainer to decide. You
> > > may require people to run and test it as their review, but I require
> > > that people understand the code I write and look for those flaws that
> > > 99% of tests wont catch.
> > > 
> > > I run lots of specific tests on the code I write, I don't expect those
> > > that review my code to do the same. In fact that's never what I even
> > > ask for when I ask someone to review my code. Note, I do ask for
> > > testers when I want people to test it, but those are not the same
> > > people that review my code.
> > 
> > Very few subsystems have dedicated testers and hence rely on the
> > test environments that the subsystem developers use every day to
> > test their own code. IOWs, in most cases "tester" and the "reviewer"
> > roles are performed by the same people.
> > 
> > > I find the reviewers of my code to be the worse testers. That's because
> > > those that I ask to review my code know what it's suppose to do, and
> > > those are the people that are not going to stumble over bugs. It's the
> > > people that have no idea how your code works that will trigger the most
> > > bugs in testing it. My best testers would be my worse reviewers.
> > 
> > "Reviewers are the worst testers".
> > 
> > Yet you accept the code they write as sufficiently well tested for
> > merging? :/
> > 
> > > What do you require as a test anyway? I could boot your patches, but
> > > since I don't have an XFS filesystem, I doubt that would be much use
> > > for you.
> > 
> > I don't want you to review XFS code - you have no domain specific
> > knowledge nor a test environment for XFS changes. IOWs, you meet
> > none of the requirements to give a "reviewed-by" for an XFS change,
> > and so to say you reviewed a change makes a mockery of the
> > expectations outlines in the SubmittingPatches guidelines.
> > 
> > Similarly, I would expect any other maintainer to give me the same
> > "go read the guidelines - you know better than that" line if I did
> > the same thing for a patch that I clearly don't have a clue about or
> > are able to test.
> > 
> > Reviewed-by only has value when it is backed by process and domain
> > specific knowledge. If the person giving that tag doesn't have
> > either of these, then it's worthless and they need to be taught what
> > the correct thing to do is. Most people (even projects) don't learn
> > proper software engineering processes until after they have been at
> > the pointy end of a pile of crap at least once. :/
> 
> Hi Dave,
> 
> For various kernel subsystems, the situation appears to be like this:
> there are few reviewers who have the technical ability to understand
> the code. The reason why this email thread started is indeed the
> "difficulty recruiting and retaining reviewers" (quoting Paul E.
> McKenney).
> 
> On the other hand, testing can be automated, baby-sitted in a
> continuous integration infrastructure. Code review cannot be automated
> in that way.
> 
> You argue that anyone doing "review" should be running tests in order
> to abide by the Reviewer's statement of oversight. Even if your
> understanding of the Documentation/SubmittingPatches wording was
> accurate, it sounds counter-productive to me, because it would keep
> away people who have the technical knowledge to review code, but limited
> time and hardware available to test it.
> 
> I also disagree with your interpretation that "free of known issues
> which would argue against its inclusion" imply that testing needs to
> be performed by the reviewer. It merely states that if unresolved issues
> were brought to the knowledge of the reviewer, then the patch would not
> be "free of known issues". It does not imply any active involvement in
> testing, semantically speaking.

I believe that this will vary from subsystem to subsystem.  I expect that
some subsystems are more amenable to straight testing than others.  I would
not agree that a mostly-testing approach to validation is a good match for
RCU, but it probably is for other subsystems.

							Thanx, Paul

