Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab3J1JaN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 05:30:13 -0400
Received: from alerce.vps.bitfolk.com ([85.119.82.134]:40219 "EHLO
	alerce.vps.bitfolk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172Ab3J1JaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 05:30:11 -0400
Date: Mon, 28 Oct 2013 09:29:55 +0000
From: Rodrigo Campos <rodrigo@sdfg.com.ar>
To: Namhyung Kim <namhyung@kernel.org>
Cc: namhyung.kim@lge.com, linux-kernel@vger.kernel.org,
        acme@ghostprotocols.net, asharma@fb.com, fweisbec@gmail.com
Subject: Re: State of "perf: Add a new sort order: SORT_INCLUSIVE"
Message-ID: <20131028092955.GB7482@sdfg.com.ar>
References: <20131025150721.GA12534@sdfg.com.ar>
 <8761si9e1u.fsf@sejong.aot.lge.com>
 <20131028084244.GA7482@sdfg.com.ar>
 <877gcx92yd.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877gcx92yd.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 06:09:30PM +0900, Namhyung Kim wrote:
> On Mon, 28 Oct 2013 08:42:44 +0000, Rodrigo Campos wrote:
> > On Mon, Oct 28, 2013 at 02:09:49PM +0900, Namhyung Kim wrote:
> >> Anyway, You can find the series and discussion on the link below:
> >> 
> >>   https://lkml.org/lkml/2012/9/13/81
> >
> > I've read the cover letter for that series and probably because I don't know
> > about perf internals I have a question: How will "--culumate" interact with
> > "--sort=dso" for example ?
> >
> > I mean, is it possible for that to show more than 100% ? (if you add all the
> > 93.35% in your example in the cover letter, or something similar). Or
> > "--culumate --sort=dso" will just group together all entries that have a dso in
> > the call chain ?
> 
> Hmm.. I think --cumulate option is only meaningful when sort order
> includes symbol.  Maybe I can add support for --sort=dso case as well
> but not sure it's worth.  Do you think it's really needed?

I don't know if it is *needed*, but that was what I need :)

I mean, what I was looking for is a way to know the percentage spent when some
symbol in the call chain belongs to a DSO. Like group all samples that have a
symbol of a DSO in the callchain, and know the percentage for that group.
Something like the "inclusive" time spent inside a library.


> > Sorry if the question was too obvious if I knew about perf internals :S
> 
> No need to sorry about it. :)

Thanks =)




Thanks again,
Rodrigo
