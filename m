Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381AbaHMKVP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 06:21:15 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:44813 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbaHMKVO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 06:21:14 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: =?ISO-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Christopher Barry <christopher.r.barry@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: OT: Open letter to the Linux World
Date: Wed, 13 Aug 2014 12:21:12 +0200
Message-ID: <14520506.bM73iQ1YOy@merkaba>
User-Agent: KMail/4.15 pre (Linux/3.16.0-tp520-fixcompwrite+; KDE/4.13.3; x86_64; git-411eff3; 2014-08-11)
In-Reply-To: <yw1xegwk3e6q.fsf@unicorn.mansr.com>
References: <20140812153812.2923046a@monolith.infinux.org> <2838655.H5W5zNkR37@merkaba> <yw1xegwk3e6q.fsf@unicorn.mansr.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 13. August 2014, 10:57:01 schrieb Måns Rullgård:
> Martin Steigerwald <Martin@lichtvoll.de> writes:
> > Am Mittwoch, 13. August 2014, 10:27:56 schrieb Peter Zijlstra:
> >> On Tue, Aug 12, 2014 at 11:07:05PM +0100, Måns Rullgård wrote:
> >> > Steven Rostedt <rostedt@goodmis.org> writes:
> >> > > Nice rant, I sympathize with you (just complaining about this on G+).
> >> >
> >> > 
> >> >
> >> > Made my day.
> >> >
> >> > 
> >> >
> >> > > I'm just waiting for Linus to get pissed enough to write his own init
> >> > > routine. Maybe he'll call it "Boot Init Through Computer Hardware".
> >> >
> >> > 
> >> >
> >> > The trouble is that most of the heavy-weight kernel developers don't
> >> > seem to care at all about what goes on in userspace.
> >>
> >> 
> >>
> >> Well, I know for a fact that quite a number do; but so far most people
> >> who care have been able to steer clear of this trainwreck so we did.
> >>
> >> 
> >>
> >> I'm about to switch all my machines to Gentoo (from Debian) because that
> >> will indeed allow you to build a distro without much of this nonsense
> >> in -- because as has been eloquently said; you simply don't need this
> >> fucking shite to run a 'normal' machine.
> >>
> >> 
> >>
> >> And the thing is; we're all very busy so we tend to take the 'easy' way
> >> out for things like this; but wholesale switching all my machines is
> >> indeed painful, and I'm not liking.
> > 
> > Just for record:
> > 
> > Debian continues and will (for now and supposedly Jessie lifetime)
> > continue to work without systemd as PID 1 using systemd-shim and
> > cgmanager.
> 
> For now.  Non-systemd configurations will receive little testing, if
> any.  Once enough breakage accumulates, someone will issue an ultimatum
> for dropping such support entirely unless those who complain fix
> everything within an unreasonably short time.  Obviously most things
> will remain broken, because those who opposed systemd are not package
> maintainers and have other jobs to do, and non-systemd support will be
> removed.  I expect this to happen in unstable/testing within 18 months.

I usually do not engage in predictions of the future, you know… my crystal 
ball has holidays.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
