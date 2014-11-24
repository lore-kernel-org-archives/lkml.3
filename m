Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030AbaKXQbe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 11:31:34 -0500
Received: from mailsec109.isp.belgacom.be ([195.238.20.105]:50438 "EHLO
	mailsec109.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752416AbaKXQbc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 11:31:32 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=hkFBDakPHWYIOok4y3pcivnmCJQbEK2MeX2RAJ8hs1E= c=1 sm=2
 a=IkcTkHD0fZMA:10 a=IJv9LcIfAAAA:8 a=20KFwNOVAAAA:8
 a=9uLPIyK3dP8K8wDVRIYA:9 a=QEXdDO2ut3YA:10
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjgGABRcc1TD7hTT/2dsb2JhbABbgw5VWYMGs08EBpQ/hmoCgR4WAQEBAQF9hAIBAQEDASNWBQsFBhgCAhgOAgJXBhMRiCcNCboQhn6PBQEBAQcCAR+BLYUNhmaDaweCeYFVBZdNiSeVJ4N+RzABgkoBAQE
Date: Mon, 24 Nov 2014 17:31:30 +0100 (CET)
From: Fabian Frederick <fabf@skynet.be>
Reply-To: Fabian Frederick <fabf@skynet.be>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <576034572.414195.1416846690634.open-xchange@webmail.nmp.skynet.be>
In-Reply-To: <1416774446.6651.56.camel@perches.com>
References: <1416689800-27146-1-git-send-email-fabf@skynet.be> <1416774446.6651.56.camel@perches.com>
Subject: Re: [PATCH 1/1] scripts: add a graph generator based on checkpatch
 reports
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.2.2-Rev27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> On 23 November 2014 at 21:27 Joe Perches <joe@perches.com> wrote:
>
>
> On Sat, 2014-11-22 at 21:56 +0100, Fabian Frederick wrote:
> > This script generates a graph based on errors/warnings/checks detected
> > by checkpatch -f recursively on each files of a directory.
> > Results are grouped by subfolders and pushed in gnuplot datasets.
>
> Why is this useful?
>
> Ingo's badly named script does something similar:
> http://people.redhat.com/mingo/x86.git/code-quality
>
> just without the plots.
>
> btw:  this line:
>
> $files = `find $statdir -name "*.c"`;
>
> should probably be
>
> $files = `git ls-files -- "$statdir/*.[ch]"`;
>

This script was meant for reporting so it's just useful because of the
graphs and the fact it can do all in one operation.

Most of all, when someone does a talk and shows up some graph,
it would be both easier and valid to tell it's using scripts/checkstat
on kernel x.y rather than sparse operations someone won't
easily reproduce.

I don't think using directly git operations would be a good thing.
This script could be used directly downloading tar.gz without it.
(Of course Git could be bring nice options in future versions :)).

Regards,
Fabian
