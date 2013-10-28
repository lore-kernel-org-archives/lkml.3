Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691Ab3J1InC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 04:43:02 -0400
Received: from alerce.vps.bitfolk.com ([85.119.82.134]:40203 "EHLO
	alerce.vps.bitfolk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab3J1Im7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 04:42:59 -0400
Date: Mon, 28 Oct 2013 08:42:44 +0000
From: Rodrigo Campos <rodrigo@sdfg.com.ar>
To: Namhyung Kim <namhyung@kernel.org>
Cc: namhyung.kim@lge.com, linux-kernel@vger.kernel.org,
        acme@ghostprotocols.net, asharma@fb.com, fweisbec@gmail.com
Subject: Re: State of "perf: Add a new sort order: SORT_INCLUSIVE"
Message-ID: <20131028084244.GA7482@sdfg.com.ar>
References: <20131025150721.GA12534@sdfg.com.ar>
 <8761si9e1u.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8761si9e1u.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 02:09:49PM +0900, Namhyung Kim wrote:
> Hi Rodrigo,
> 
> On Fri, 25 Oct 2013 16:07:21 +0100, Rodrigo Campos wrote:
> >
> > That will be useful for me and I was wondering if you are still working on that
> > or if there is a newer version than v6:
> >
> > 	http://thread.gmane.org/gmane.linux.kernel.perf.user/882
> >
> >
> > Maybe you have a newer version of it not sent to the list ? Or do you plan to
> > work on it anytime soon ?
> >
> > If there is any branch to test, please let me know :)
> 
> Yes I have a patch series for that.  But it's not a new sort order but a
> new command line option --culumate.  I don't think it should be a new
> sort order since it affects only how it counts period value on each
> sample not how samples are sorted/grouped.
> 
> It's about a year since I sent this series to list.  I'll work on it and
> send it to the list soon.  But before that I have to re-read what's the

Great, thanks a lot!

> Frederic's concern - IIRC it's about consolidating code in perf report
> that does similar things on branch stack.
> 
> Frederic, can you remember what was the problem?
> 
> Anyway, You can find the series and discussion on the link below:
> 
>   https://lkml.org/lkml/2012/9/13/81

I've read the cover letter for that series and probably because I don't know
about perf internals I have a question: How will "--culumate" interact with
"--sort=dso" for example ?

I mean, is it possible for that to show more than 100% ? (if you add all the
93.35% in your example in the cover letter, or something similar). Or
"--culumate --sort=dso" will just group together all entries that have a dso in
the call chain ?

Sorry if the question was too obvious if I knew about perf internals :S




Thanks a lot,
Rodrigo
