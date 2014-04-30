Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758223AbaD3IgY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 04:36:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39550 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754235AbaD3IgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 04:36:22 -0400
Date: Wed, 30 Apr 2014 10:36:20 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Jidong Xiao <jidong.xiao@gmail.com>
Cc: Kernel development list <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: Is heap_stack_gap useless?
Message-ID: <20140430083620.GA4711@dhcp22.suse.cz>
References: <CAG4AFWaemUiR1HTx5dUUQf3V4twuwuiBdtDLNEeEoF-ikTThpQ@mail.gmail.com>
 <CAG4AFWa0MGEZvyqq5VWCpsQGFCGbu-16V_djv_sEW6YV3VDSGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG4AFWa0MGEZvyqq5VWCpsQGFCGbu-16V_djv_sEW6YV3VDSGw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 29-04-14 23:59:09, Jidong Xiao wrote:
> On Tue, Apr 29, 2014 at 11:31 PM, Jidong Xiao <jidong.xiao@gmail.com> wrote:
> > Hi,
> >
> > I noticed this variable, defined in mm/nommu.c,
> >
> > mm/nommu.c:int heap_stack_gap = 0;
> >
> > This variable only shows up once, and never shows up in elsewhere.
> >
> > Can some one tell me is this useless? If so, I will submit a patch to remove
> > it.

Hint: Do not be afraid to do a bit of git research when you want to do
clean-ups like this.
-- 
Michal Hocko
SUSE Labs
