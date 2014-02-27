Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165AbaB0MfN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 07:35:13 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:58432 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704AbaB0MfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 07:35:11 -0500
Date: Thu, 27 Feb 2014 13:35:07 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andi Kleen <andi@firstfloor.org>, Stephane Eranian <eranian@google.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [PATCH v3 00/14] perf, x86: Haswell LBR call stack support
Message-ID: <20140227123507.GB11475@gmail.com>
References: <1392703661-15104-1-git-send-email-zheng.z.yan@intel.com>
 <530D53EF.9090706@amacapital.net>
 <CABPqkBSECV6iG4T60-OTZsV2CrCtV=awUSt7SGLTdkX9i8T90g@mail.gmail.com>
 <CALCETrWXDYsxXBWPqNS8cK69756DNj5sUyk-Fho2r_5_wh-=mg@mail.gmail.com>
 <20140226185513.GL22728@two.firstfloor.org>
 <CALCETrVQ8SBg+YLuPmDevL+f2dzBjLJucfMvVHaB04E8QJSGXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVQ8SBg+YLuPmDevL+f2dzBjLJucfMvVHaB04E8QJSGXw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andy Lutomirski <luto@amacapital.net> wrote:

> On Wed, Feb 26, 2014 at 10:55 AM, Andi Kleen <andi@firstfloor.org> wrote:
>
> >> I'm suggesting a perf event option, just like the way that PEBS 
> >> works.
> >
> > Right now it's a somewhat experimental feature and just having the 
> > sysctl is fine. [...]

NACKed-by: Ingo Molnar <mingo@kernel.org>

> > [...] If it turns out that is what everyone uses such an option 
> > could be still added later.
> 
> I'm a bit worried that the syscall will be stuck as ABI forever, 
> though.  Its presence will make adding a different configuration 
> mechanism awkward.

The sysctl is a usability non-starter, obviously.

Thanks,

	Ingo
