Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbbAVPX2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 10:23:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753190AbbAVPX0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 10:23:26 -0500
Date: Thu, 22 Jan 2015 16:23:15 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf ui/tui: Show fatal error message only if exists
Message-ID: <20150122152315.GA32650@krava.brq.redhat.com>
References: <1421736050-5283-1-git-send-email-namhyung@kernel.org>
 <20150120124926.GB15315@krava.brq.redhat.com>
 <20150122150834.GA16455@danjae>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150122150834.GA16455@danjae>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 12:08:34AM +0900, Namhyung Kim wrote:

SNIP

> > >  				    "Press any key...", 0);
> > 
> > looks like we display ui_helpline__last_msg also in ui/browsers/annotate.c
> 
> Right, I also saw it.
> 
> > 
> > do we want to have some common function that unsets tui_helpline__set
> > so we're sure we dont get the message twice?
> 
> I doubt that it's really needed..  The annotation code does not
> propagate an error so the wait_for_ok arg in ui__exit() will be always
> false.  In addition, I think it's better to use ui__error() or
> ui__warning() directly at the point when something bad happened and we
> need to inform user.

ok..

Acked-by: Jiri Olsa <jolsa@kernel.org>

jirka

