Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490Ab3FZQBx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 12:01:53 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:61310 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab3FZQBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 12:01:52 -0400
Message-ID: <1372262508.8776.83.camel@marge.simpson.net>
Subject: Re: Scheduler accounting inflated for io bound processes.
From: Mike Galbraith <bitbucket@online.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Dave Chiluk <chiluk@canonical.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Date: Wed, 26 Jun 2013 18:01:48 +0200
In-Reply-To: <20130626155048.GA7399@gmail.com>
References: <51C35C05.1070005@canonical.com>
	 <1372176104.7497.86.camel@marge.simpson.net>
	 <1372182534.7497.129.camel@marge.simpson.net>
	 <20130626093713.GA27385@gmail.com>
	 <20130626104243.GE28407@twins.programming.kicks-ass.net>
	 <20130626155048.GA7399@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:Vo0oDDOC8HkOFr8mcErYaiwTz5qH/pvk+DcIKz+DNlO
 qWn3HxXRyJ8sdlUl00ev98MaLGP+5g29lJsDOLqBO0CYBz9Xth
 /6WD6t5+a8bmT3mvia5/iYlBhFyyDk/4IBeY1nGPHSOTPoFLP9
 FiaX7xkebckcTAfx9hYxRVrvEpBx5tawkZLnbc3Yn0ts/Lc7zr
 HSDLqtzKRETVBWxljgpVnLiFpmDDvXXRiz4GM2LlXdPC3DX3M9
 0+R7vftHJfG4s36P0cwe9TVofYs/Zz3hR5kUZeno+jwiMBaQco
 Y8kBU1XcX8NlAKkGHz3NmEYgK6SpZ2TBVRjxLFqeJ0mXFqTZZS
 H1I6kDsa91gzXCF7XABTjn04+SS3KmdSncAJG25tMKNHEshd7L
 J57v/YISUgsLg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-26 at 17:50 +0200, Ingo Molnar wrote: 
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Wed, Jun 26, 2013 at 11:37:13AM +0200, Ingo Molnar wrote:
> > > Would be very nice to randomize the sampling rate, by randomizing the 
> > > intervals within a 1% range or so - perf tooling will probably recognize 
> > > the different weights.
> > 
> > You're suggesting adding noise to the regular kernel tick?
> 
> No, to the perf interval (which I assumed Mike was using to profile this?)

Yeah, perf top -F 250 exhibits the same inaccuracy as 250 Hz tick cpu
accounting.  (sufficient sample jitter should cure it, but I think I'd
prefer to just live with it)

-Mike

