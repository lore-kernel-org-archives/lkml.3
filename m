Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbbAGODL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 09:03:11 -0500
Received: from mail-oi0-f49.google.com ([209.85.218.49]:48105 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbbAGODK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 09:03:10 -0500
MIME-Version: 1.0
In-Reply-To: <20150104164754.GD22707@krava.brq.redhat.com>
References: <1419656793-32756-1-git-send-email-namhyung@kernel.org>
 <1419656793-32756-3-git-send-email-namhyung@kernel.org> <20150104164754.GD22707@krava.brq.redhat.com>
From: Namhyung Kim <namhyung@kernel.org>
Date: Wed, 7 Jan 2015 23:02:49 +0900
X-Google-Sender-Auth: FG8BZcWbV1C4jgWfrWE3iVF6EiM
Message-ID: <CAM9d7cjQ=SW6nMoT3t-2JUvcxXta2B=imRXU6SvdM21joyfwMQ@mail.gmail.com>
Subject: Re: [PATCH 3/5] perf diff: Print diff result more precisely
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 5, 2015 at 1:47 AM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Sat, Dec 27, 2014 at 02:06:31PM +0900, Namhyung Kim wrote:
>> Current perf diff result is somewhat confusing since it sometimes hide
>> small result and sometimes there's no result.  So do not hide small
>> result (less than 0.01%) and print "N/A" if baseline is not
>> recorded (for ratio and wdiff only).  Blank means the baseline is
>> available but its pairs are not.
>
> I think we should document this, especialy when diff has different
> behaviour from the rest of the computation.. :-\

Well, probably I'm missing something but I don't know what needs to be
documented.  Currently perf diff doesn't show small result so it's
hard to distinguish entries that have small result and no result.  But
to sort the output properly, it needs to show the results and I think
it's natural to not hide the result to user.


>
> anyway for the change itself:
>
> Acked-by: Jiri Olsa <jolsa@kernel.org>

Thanks,
Namhyung
