Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620AbaBTTIq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 14:08:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50772 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754693AbaBTTIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 14:08:45 -0500
Date: Thu, 20 Feb 2014 20:08:16 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: akpm@linux-foundation.org, eparis@redhat.com, sgrubb@redhat.com,
        peterz@infradead.org, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7][RFC] pid: changes to support audit
Message-ID: <20140220190816.GD23993@redhat.com>
References: <20131220140417.GE14884@madcap2.tricolour.ca> <8aa73d2b884439496f87d5f34c12ba9b4b40f7e5.1377032086.git.rgb@redhat.com> <ae3d74e79649d9e4962d0da030fb4852ddc5b8d1.1387227114.git.rgb@redhat.com> <20131217095801.GF21999@twins.programming.kicks-ass.net> <20131220044826.GF14944@madcap2.tricolour.ca> <20131220085846.GA21999@twins.programming.kicks-ass.net> <cover.1390495874.git.rgb@redhat.com> <20140219161858.GN16640@madcap2.tricolour.ca> <20140219174745.GA9784@redhat.com> <20140219181501.GO16640@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140219181501.GO16640@madcap2.tricolour.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19, Richard Guy Briggs wrote:
>
> On 14/02/19, Oleg Nesterov wrote:
> >
> > But at first glance, can't you send 2/7 first and join 1/7 and 3/7?
>
> Yes, Peter made the same observation.  I thought it was more useful to
> have them seperated out, but I'll join them.

Yes, thanks, I think it doesn't make sense to uglify the code in 1/7
and then fix it in 2/7.

> > And since you change is_global_init() perhaps you can also fix it?
> > It actually needs tgid.
>
> Sure.  Can you explain why?  We only want init killing off its own
> threads?

Please see my reply to 5/7.

Oleg.

