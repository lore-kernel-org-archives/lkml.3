Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbaB0QId (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 11:08:33 -0500
Received: from one.firstfloor.org ([193.170.194.197]:60076 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbaB0QIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 11:08:32 -0500
Date: Thu, 27 Feb 2014 17:08:30 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [PATCH v3 00/14] perf, x86: Haswell LBR call stack support
Message-ID: <20140227160830.GQ22728@two.firstfloor.org>
References: <1392703661-15104-1-git-send-email-zheng.z.yan@intel.com>
 <530D53EF.9090706@amacapital.net>
 <CABPqkBSECV6iG4T60-OTZsV2CrCtV=awUSt7SGLTdkX9i8T90g@mail.gmail.com>
 <CALCETrWXDYsxXBWPqNS8cK69756DNj5sUyk-Fho2r_5_wh-=mg@mail.gmail.com>
 <20140226185513.GL22728@two.firstfloor.org>
 <CALCETrVQ8SBg+YLuPmDevL+f2dzBjLJucfMvVHaB04E8QJSGXw@mail.gmail.com>
 <20140227123507.GB11475@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140227123507.GB11475@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 01:35:07PM +0100, Ingo Molnar wrote:
> 
> * Andy Lutomirski <luto@amacapital.net> wrote:
> 
> > On Wed, Feb 26, 2014 at 10:55 AM, Andi Kleen <andi@firstfloor.org> wrote:
> >
> > >> I'm suggesting a perf event option, just like the way that PEBS 
> > >> works.
> > >
> > > Right now it's a somewhat experimental feature and just having the 
> > > sysctl is fine. [...]
> 
> NACKed-by: Ingo Molnar <mingo@kernel.org>

You forgot to propose an alternative? 

-Andi
