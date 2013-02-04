Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282Ab3BDNeQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 08:34:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27884 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834Ab3BDNeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 08:34:15 -0500
Date: Mon, 4 Feb 2013 14:33:53 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>, Stephane Eranian <eranian@google.com>,
        linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        acme@redhat.com, namhyung.kim@lge.com
Subject: Re: [PATCH 0/2] perf: add new uncore command
Message-ID: <20130204133353.GC1058@krava.brq.redhat.com>
References: <1359640479-5289-1-git-send-email-eranian@google.com>
 <878v78togq.fsf@sejong.aot.lge.com>
 <20130202013523.GA2889@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130202013523.GA2889@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2013 at 05:35:23PM -0800, Andi Kleen wrote:
> > And there's a patchset [1] from Jiri to support some kind of formula -
> > yeah, now I've written the correct spelling. :) - that might fit to this
> > purpose if you provide suitable formula file IMHO.  So I guess we don't
> > need to have another command and can reuse perf stat, no?
> 
> Yes with a proper expression engine it's all redundant. I haven't 
> looked at Jiri's stuff in detail, but it seemed very simple-minded
> and may not support all the computation needed.

yep, it was just an idea proposal.. it'd need more changes
too be able to handle this uncore stuff, but it's possible

> 
> Also would allow to finally replace the bogus perf stat -d frontend/backend
> counters.

yep

> 
> For stat there's no really a compelling reason to integrate
> it, the usual wrappers work as well. They have the advantage that
> they can be written in real programing languages, instead of trying
> to invent a new one.
> 
> Expressions integrated would be mainly useful for things like
> "counting perf top"

nice idea

jirka
