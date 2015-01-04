Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785AbbADQsH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 11:48:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51245 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397AbbADQsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 11:48:05 -0500
Date: Sun, 4 Jan 2015 17:47:54 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 3/5] perf diff: Print diff result more precisely
Message-ID: <20150104164754.GD22707@krava.brq.redhat.com>
References: <1419656793-32756-1-git-send-email-namhyung@kernel.org>
 <1419656793-32756-3-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419656793-32756-3-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 27, 2014 at 02:06:31PM +0900, Namhyung Kim wrote:
> Current perf diff result is somewhat confusing since it sometimes hide
> small result and sometimes there's no result.  So do not hide small
> result (less than 0.01%) and print "N/A" if baseline is not
> recorded (for ratio and wdiff only).  Blank means the baseline is
> available but its pairs are not.

I think we should document this, especialy when diff has different
behaviour from the rest of the computation.. :-\

anyway for the change itself:

Acked-by: Jiri Olsa <jolsa@kernel.org>

thanks,
jirka
