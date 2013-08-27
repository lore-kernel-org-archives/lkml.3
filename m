Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513Ab3H0ONw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 10:13:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14764 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186Ab3H0ONv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 10:13:51 -0400
Date: Tue, 27 Aug 2013 10:13:30 -0400
From: Dave Jones <davej@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: suspicious RCU usage (perf)
Message-ID: <20130827141330.GA21890@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	David Ahern <dsahern@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20130826145838.GA8377@redhat.com>
 <20130826162928.GQ3871@linux.vnet.ibm.com>
 <20130826133041.3d750b1b@gandalf.local.home>
 <20130826175012.GA25202@redhat.com>
 <20130826141814.54dcaa89@gandalf.local.home>
 <20130826182907.GB25202@redhat.com>
 <521BAFD3.2060404@gmail.com>
 <20130826194923.GA1549@redhat.com>
 <20130827091011.18ed8b59@gandalf.local.home>
 <521CB074.3040900@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <521CB074.3040900@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 07:58:12AM -0600, David Ahern wrote:
 > On 8/27/13 7:10 AM, Steven Rostedt wrote:
 > > On Mon, 26 Aug 2013 15:49:24 -0400
 > > Dave Jones <davej@redhat.com> wrote:
 > >
 > >
 > >>   > Do you have /sys/kernel/debug with access permissions?
 > >>
 > >> Ah, yeah, that'll be it. Good catch.
 > >>
 > >> Sorry for the false alarm Steve ;)
 > >
 > > Yeah, but it still does not explain how perf got started. Perf requires
 > > a sys_perf_event_open() call to run.
 > 
 > Per Peter's response another option is the paranoia level:
 > 
 > # perf event paranoia level:
 > # -1 - not paranoid at all
 > #  0 - disallow raw tracepoint access for unpriv
 > #  1 - disallow cpu events for unpriv
 > #  2 - disallow kernel profiling for unpriv
 > kernel.perf_event_paranoid = -1

This I have set to 1 on that box. (The default)

	Dave

