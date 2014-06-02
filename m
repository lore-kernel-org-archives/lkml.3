Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbaFBUZz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 16:25:55 -0400
Received: from mail.efficios.com ([78.47.125.74]:48419 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753783AbaFBUZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 16:25:54 -0400
Date: Mon, 2 Jun 2014 20:25:51 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: paulmck@linux.vnet.ibm.com
Cc: josh@joshtriplett.org, Joe Perches <joe@perches.com>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com, sbw@mit.edu
Message-ID: <735924028.25620.1401740751632.JavaMail.zimbra@efficios.com>
In-Reply-To: <20140602192729.GB22231@linux.vnet.ibm.com>
References: <1401728420-3572-1-git-send-email-paulmck@linux.vnet.ibm.com> <20140602174837.GA13257@cloud> <1401731968.7323.4.camel@joe-AO725> <20140602181658.GX22231@linux.vnet.ibm.com> <20140602185635.GB13569@cloud> <20140602190821.GZ22231@linux.vnet.ibm.com> <20140602191155.GB13648@cloud> <20140602192729.GB22231@linux.vnet.ibm.com>
Subject: Re: [PATCH RFC 1/2] MAINTAINERS: Add "R:" designated-reviewers tag
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [173.246.13.210]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF29 (Linux)/8.0.5_GA_5839)
Thread-Topic: MAINTAINERS: Add "R:" designated-reviewers tag
Thread-Index: hq3RwJauceyxrBLSpQYOKEAtZevk2Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> To: josh@joshtriplett.org
> Cc: "Joe Perches" <joe@perches.com>, linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
> dipankar@in.ibm.com, akpm@linux-foundation.org, "mathieu desnoyers" <mathieu.desnoyers@efficios.com>,
> niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
> edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com, sbw@mit.edu
> Sent: Monday, June 2, 2014 3:27:29 PM
> Subject: Re: [PATCH RFC 1/2] MAINTAINERS: Add "R:" designated-reviewers tag
> 
> On Mon, Jun 02, 2014 at 12:11:55PM -0700, josh@joshtriplett.org wrote:
> > On Mon, Jun 02, 2014 at 12:08:21PM -0700, Paul E. McKenney wrote:
> > > On Mon, Jun 02, 2014 at 11:56:35AM -0700, josh@joshtriplett.org wrote:
> > > > On Mon, Jun 02, 2014 at 11:16:58AM -0700, Paul E. McKenney wrote:
> > > > > On Mon, Jun 02, 2014 at 10:59:28AM -0700, Joe Perches wrote:
> > > > > > On Mon, 2014-06-02 at 10:48 -0700, josh@joshtriplett.org wrote:
> > > > > > > On Mon, Jun 02, 2014 at 10:22:58AM -0700, Joe Perches wrote:
> > > > > > > > On Mon, 2014-06-02 at 10:00 -0700, Paul E. McKenney wrote:
> > > > > > > > > A ksummit-discuss email thread looked at the difficulty
> > > > > > > > > recruiting
> > > > > > > > > and retaining reviewers.
> > > > > > > > 
> > > > > > > > []
> > > > > > > > 
> > > > > > > > > Paul Walmsley also noted the need for patch
> > > > > > > > > submitters to know who the key reviewers are and suggested
> > > > > > > > > adding an
> > > > > > > > > "R:" tag to the MAINTAINERS file to record this information
> > > > > > > > > on a
> > > > > > > > > per-subsystem basis.
> > > > > > > > 
> > > > > > > > I'm not sure of the value of this.
> > > > > > > > 
> > > > > > > > Why not just mark the actual reviewers as maintainers?
> > > > > > > 
> > > > > > > As discussed in the kernel summit discussion, being a regular
> > > > > > > patch
> > > > > > > reviewer isn't the same thing as being *the* maintainer.
> > > > > > 
> > > > > > I think it's not particularly important or valuable
> > > > > > here to make that distinction.
> > > > > > 
> > > > > > What real difference does it make?
> > > > > 
> > > > > In the particular case of Josh, none, at least from my viewpoint.  He
> > > > > of
> > > > > course might or might not want to take on additional maintainership
> > > > > responsibility at this particular point in time, in which case, I
> > > > > would
> > > > > be more than happy to have him as a designated maintainer.
> > > > 
> > > > For the record, I'd be happy to be listed as a co-maintainer for RCU.
> > > > :)
> > > 
> > > I would be happy to put you down as maintainer and Steven down as
> > > official reviewer.  ;-)
> > 
> > I'd suggest adding Mathieu Desnoyers, Oleg Nesterov, and Lai Jiangshan
> > as reviewers as well, with their consent.
> 
> Mathieu, Oleg, Lai, any objections?

No objection from me. I'm always glad to help out
reviewing RCU patches whenever I have some cycles
available.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
