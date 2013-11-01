Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab3KAJSg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 05:18:36 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:34922 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420Ab3KAJSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 05:18:35 -0400
MIME-Version: 1.0
In-Reply-To: <20131101075502.GA25547@gmail.com>
References: <1383202576-28141-1-git-send-email-namhyung@kernel.org>
	<20131031080932.GA8479@gmail.com>
	<87vc0c4ny2.fsf@sejong.aot.lge.com>
	<20131101075502.GA25547@gmail.com>
Date: Fri, 1 Nov 2013 11:18:33 +0200
X-Google-Sender-Auth: lKd84ipVIBe4tfbmT9iOgih4O_A
Message-ID: <CAOJsxLF7+KZ0uVHU3mXo9z=wUMajn4OEHDcayX=D95Viu=zwzg@mail.gmail.com>
Subject: Re: [RFC/PATCHSET 00/14] perf report: Add support to accumulate hist
 periods (v2)
From: Pekka Enberg <penberg@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Arun Sharma <asharma@fb.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 1, 2013 at 9:55 AM, Ingo Molnar <mingo@kernel.org> wrote:
> Btw., if anyone is interested in improving the GTK front-end, it
> would be _really_ nice if it had a 'start profiling' button like
> sysprof has today, with a 'samples' field showing the current number
> of samples. (We could even improve upon sysprof by adding 'stop'
> functionality as well ;-)
>
> A bit like perf top, except the reporting session is hidden until
> the user actively requests the profile.
>
> Maybe it could even be called a gtk version of 'perf top', with a
> button to start/stop collection, with another button to
> activate/deactivate reporting output, and yet another button to
> reset the profiling buffer.
>
> With that feature set perf would be a ready sysprof workflow
> replacement I think. (I've Cc:-ed Pekka, just in case! :-)

Sure, "start/stop" button is useful for system-wide profiling but you
also want to be able to start an application for profiling from the UI.
I don't remember if SysProf supports that but the Shark profiler on Mac
OS X does.

Btw, to make GTK-front end even more useful, we should:

  (1) Have a drop-down for selecting a specific process from system-wide
      profile.

  (2) Show 'perf annotate' from 'perf report' when a function is
      double-clicked.

                        Pekka
