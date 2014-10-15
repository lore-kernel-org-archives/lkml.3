Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751511AbaJOSsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 14:48:19 -0400
Received: from mail.kernel.org ([198.145.19.201]:59460 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721AbaJOSsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 14:48:18 -0400
Date: Wed, 15 Oct 2014 15:48:12 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Taeung Song <treeze.taeung@gmail.com>, linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH resend] perf top: Add a visual cue for toggle zeroing of
 samples
Message-ID: <20141015184812.GL3198@kernel.org>
References: <1412665995-26359-1-git-send-email-treeze.taeung@gmail.com>
 <87wq8bfksv.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wq8bfksv.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Oct 08, 2014 at 09:48:48AM +0900, Namhyung Kim escreveu:
> Hi Taeung,
> 
> On Tue,  7 Oct 2014 16:13:15 +0900, Taeung Song wrote:
> > When 'perf top' is run, one can't easily find a difference
> > between -z option and normal output.
> > So I added a visual cue to know whether it is the zeroing or not.
> >
> > Output is as below.
> >
> > Before:
> >  $ perf top
> >
> >  Samples: 61K of event 'cycles', Event count (approx.): 3908136933
> >  Overhead  Shared Object                       Symbol
> >     1.42%  firefox                             [.] 0x0000000000011e76
> >     1.32%  libpthread-2.17.so                  [.] pthread_mutex_lock
> >
> > If you press key 'z' or run with zero option like '$ perf top --zero', it is as below.
> >
> > After:
> >  Samples: 61K of event 'cycles', Event count (approx.): 3908136933 [z]
> >  Overhead  Shared Object                       Symbol
> >     1.42%  firefox                             [.] 0x0000000000011e76
> >     1.32%  libpthread-2.17.so                  [.] pthread_mutex_lock
> >
> > Signed-off-by: Taeung Song <treeze.taeung@gmail.com>
> 
> Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks, applied.

- Arnaldo
