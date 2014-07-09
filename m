Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501AbaGIWVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 18:21:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29594 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932352AbaGIWVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 18:21:12 -0400
Date: Thu, 10 Jul 2014 00:20:47 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        acme@infradead.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 9/9] perf, tools: Add a --quiet flag to perf list
Message-ID: <20140709222047.GM20938@krava.redhat.com>
References: <1402700580-26939-1-git-send-email-andi@firstfloor.org>
 <1402700580-26939-10-git-send-email-andi@firstfloor.org>
 <1402838261.1684.39.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1402838261.1684.39.camel@leonhard>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 15, 2014 at 10:17:41PM +0900, Namhyung Kim wrote:
> Hi Andi,
> 
> 2014-06-13 (금), 16:03 -0700, Andi Kleen:
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > Add a --quiet flag to perf list to not print the event descriptions
> > that were earlier added for JSON events. This may be useful to
> > get a less crowded listing.
> > 
> > It's still default to print descriptions as that is the more useful
> > default for most users.  Requested by Namhyung Kim.
> 
> Did I request the --quiet thing?  It seems like there's a
> miscommunication.. :-/
> 
> I still prefer -v option and not printing descriptions by default - but
> want to inform users to use -v option.  However I also want to hear from
> others on this.

I dont mind descriptions by default, but 'quiet' seems more generic
than what it does now ... how about '--no-desc'

jirka
