Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000Ab3EFLhl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 07:37:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29843 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470Ab3EFLhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 07:37:12 -0400
Date: Mon, 6 May 2013 13:36:42 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Michael Ellerman <michael@ellerman.id.au>, peterz@infradead.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        rob@landley.net
Subject: Re: [RFC/PATCH] perf: Expand definition of sysfs format attribute
Message-ID: <20130506113642.GA1093@krava.brq.redhat.com>
References: <1362370865-4437-1-git-send-email-michael@ellerman.id.au>
 <20130408072422.GA4476@concordia>
 <20130506010829.GA32607@concordia>
 <20130506082008.GA2784@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130506082008.GA2784@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 06, 2013 at 05:20:08AM -0300, Arnaldo Carvalho de Melo wrote:
> Em Mon, May 06, 2013 at 11:08:30AM +1000, Michael Ellerman escreveu:
> > On Mon, Apr 08, 2013 at 05:24:22PM +1000, Michael Ellerman wrote:
> > > On Mon, Mar 04, 2013 at 03:21:05PM +1100, Michael Ellerman wrote:
> > > > Make it explicit that the format attributes may define overlapping bit
> > > > ranges. Unfortunately this was left unspecified originally, and all the
> > > > examples show non-overlapping ranges. I don't believe this is an ABI
> > > > change, as we are defining something that was previously undefined, but
> > > > others may disagree.
> > > > 
> > > > The POWER8 PMU would like to define overlapping ranges, as bit ranges in
> > > > the event code have different meanings for certain events. It will also
> > > > allow us to define an overarching "event" field, that encompasses all
> > > > others.
> > > > 
> > > > As far as I can see perf is comfortable with this change, however I am
> > > > not sure if there are any other users of the interface.
> > > 
> > > Any comments on this one?
> 
> > I think the consensus from Peter and Jiri was that this was OK, are you
> > happy to merge it?
> 
> I'll do it eventually, but now I'm on vacations, so perhaps Jiri can
> process it and push to Ingo? Jiri?

ok, I'll try to do this soon ;)

jirka
