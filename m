Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973AbaFWPsW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 11:48:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:65378 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755777AbaFWPsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 11:48:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,530,1400050800"; 
   d="scan'208";a="561945157"
Date: Mon, 23 Jun 2014 08:47:51 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>, Joe Mario <jmario@redhat.com>,
        Don Zickus <dzickus@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 1/2] perf/x86: update Haswell PEBS event constraints
Message-ID: <20140623154751.GE8178@tassilo.jf.intel.com>
References: <1403193509-22393-1-git-send-email-eranian@google.com>
 <1403193509-22393-2-git-send-email-eranian@google.com>
 <20140619180028.GU8178@tassilo.jf.intel.com>
 <20140623071454.GI19860@laptop.programming.kicks-ass.net>
 <CABPqkBTXNuKQKd-jFhAphmKnQ8PTdD7iQ66oYe7Uao_05rP8pw@mail.gmail.com>
 <20140623113759.GD13930@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140623113759.GD13930@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Filters? You mean the inv,cmask etc? Well, we have the Intel provided
> 'cycle' events that use them, so exposing them makes sense and allows
> such experimentation when we need another such alias.

The SDM explicitely discourages it.

The 'cycle' event is now handled explicitely, but for others it is still
not ok.

-Andi
