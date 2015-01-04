Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbbADQdt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 11:33:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55728 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752586AbbADQds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 11:33:48 -0500
Date: Sun, 4 Jan 2015 17:33:39 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH RESEND 2/5] perf diff: Get rid of hists__compute_resort()
Message-ID: <20150104163339.GC22707@krava.brq.redhat.com>
References: <1419656793-32756-1-git-send-email-namhyung@kernel.org>
 <1419656793-32756-2-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419656793-32756-2-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 27, 2014 at 02:06:30PM +0900, Namhyung Kim wrote:
> The hists__compute_resort() is to sort output fields based on the
> given field/criteria.  This was done without the sort list but as we
> added the field to the sort list, we can do it with normal
> hists__output_resort() using the ->sort callback.
> 

Acked-by: Jiri Olsa <jolsa@kernel.org>

thanks,
jirka
