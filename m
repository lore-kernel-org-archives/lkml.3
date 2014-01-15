Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957AbaAOAQc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 19:16:32 -0500
Received: from mga02.intel.com ([134.134.136.20]:21912 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730AbaAOAQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 19:16:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,659,1384329600"; 
   d="scan'208";a="466749182"
Date: Tue, 14 Jan 2014 16:21:21 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: intel-mid: sfi_handle_*_dev() should check for
 pdata error code
Message-ID: <20140115002121.GC18183@psi-dev26.jf.intel.com>
References: <1387244246-20714-1-git-send-email-david.a.cohen@linux.intel.com>
 <1387518179-4316-1-git-send-email-david.a.cohen@linux.intel.com>
 <1387518179-4316-2-git-send-email-david.a.cohen@linux.intel.com>
 <20131220084953.GB21133@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131220084953.GB21133@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Fri, Dec 20, 2013 at 09:49:53AM +0100, Ingo Molnar wrote:
> 
> * David Cohen <david.a.cohen@linux.intel.com> wrote:
> 
> > Prevent sfi_handle_*_dev() to register device in case
> > intel_mid_sfi_get_pdata() failed to execute.
> > 
> > Since 'NULL' is a valid return value, this patch makes
> > sfi_handle_*_dev() functions to use IS_ERR() to validate returned pdata.
> 
> Is this bug triggering in practice? If not then please say so in the 
> changelog. If yes then is this patch desired for v3.13 merging and 
> also please fix the changelog to conform to the standard changelog 
> style:
> 
>  - first describe the symptoms of the bug - how does a user notice?
> 
>  - then describe how the code behaves today and how that is causing
>    the bug
> 
>  - and then only describe how it's fixed.
> 
> The first item is the most important one - while developers 
> (naturally) tend to concentrate on the least important point, the last 
> one.

Thanks for the feedback :)
This new patch set was done in reply to your comment:
https://lkml.org/lkml/2013/12/20/517

Br, David Cohen

> 
> Thanks,
> 
> 	Ingo
