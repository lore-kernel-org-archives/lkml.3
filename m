Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751639AbaI2JV6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 05:21:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58728 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037AbaI2JV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 05:21:57 -0400
Date: Mon, 29 Sep 2014 11:21:17 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 02/11] perf tools: Refactor unit and scale function
 parameters
Message-ID: <20140929092117.GB1223@krava.brq.redhat.com>
References: <1411567455-31264-1-git-send-email-matt@console-pimps.org>
 <1411567455-31264-3-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411567455-31264-3-git-send-email-matt@console-pimps.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 03:04:06PM +0100, Matt Fleming wrote:
> From: Matt Fleming <matt.fleming@intel.com>
> 
> Passing pointers to alias modifiers 'unit' and 'scale' isn't very
> future-proof since if we add more modifiers to the list we'll end up
> passing more arguments.
> 
> Instead wrap everything up in a struct perf_pmu_info, which can easily
> be expanded when additional alias modifiers are necessary in the future.
> 
> Cc: Jiri Olsa <jolsa@redhat.com>

Acked-by: Jiri Olsa <jolsa@kernel.org>

thanks,
jirka
