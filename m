Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022AbaGaQ64 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 12:58:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60467 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449AbaGaQ6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 12:58:54 -0400
Message-ID: <53DA75C5.5010607@zytor.com>
Date: Thu, 31 Jul 2014 09:58:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Dave Hansen <dave@sr71.net>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] [RESEND][v4] x86: rework tlb range flushing code
References: <20140731154052.C7E7FBC1@viggo.jf.intel.com>
In-Reply-To: <20140731154052.C7E7FBC1@viggo.jf.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2014 08:40 AM, Dave Hansen wrote:
> x86 Maintainers,
> 
> I've sent this a couple of times and resolved all the feedback
> I've received.  It has sign-offs from Mel and Rik.  Could this
> get picked up in to the x86 tree, please?
> 
> Changes from v3:
>  * Include the patch I was using to gather detailed statistics
>    about the length of the ranged TLB flushes
>  * Fix some documentation typos
>  * Add a patch to rework the remote tlb flush code to plumb the
>    tracepoints in easier, and add missing tracepoints
>  * use __print_symbolic() for the human-readable tracepoint
>    descriptions
>  * change an int to bool in patch 1
>  * Specifically call out that we removed itlb vs. dtlb logic
> 
> Changes from v2:
>  * Added a brief comment above the ceiling tunable
>  * Updated the documentation to mention large pages and say
>    "individual flush" instead of invlpg in most cases.
> 
> I've run this through a variety of systems in the LKP harness,
> as well as running it on my desktop for a few days.  I'm yet to
> see an to see if any perfmance regressions (or gains) show up.
> 

Thanks for the resend.  Applied.

	-hpa


