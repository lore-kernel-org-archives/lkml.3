Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455Ab3ARXAm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 18:00:42 -0500
Received: from mga09.intel.com ([134.134.136.24]:5683 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755127Ab3ARXAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 18:00:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,495,1355126400"; 
   d="scan'208";a="273972242"
Date: Fri, 18 Jan 2013 15:00:40 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        acme@redhat.com, jolsa@redhat.com, namhyung.kim@lge.com
Subject: Re: [PATCH v6 05/18] perf: add minimal support for PERF_SAMPLE_WEIGHT
Message-ID: <20130118230040.GI4051@tassilo.jf.intel.com>
References: <1358264386-24633-1-git-send-email-eranian@google.com>
 <1358264386-24633-6-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358264386-24633-6-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 04:39:33PM +0100, Stephane Eranian wrote:
> Ensure we grab the weight from  raw sample struct
> and that we can dump it via perf report -D.

AFAIK i have a similar patch in the haswell patchkit.

It's straight forward of course, just have to chose one.
I think mine does slightly more.

-Andi
