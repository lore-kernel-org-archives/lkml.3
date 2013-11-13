Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751362Ab3KMVGn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 16:06:43 -0500
Received: from mga09.intel.com ([134.134.136.24]:51428 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874Ab3KMVGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 16:06:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="408358007"
Message-ID: <5283E9D9.5070006@linux.intel.com>
Date: Wed, 13 Nov 2013 13:06:33 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] ftrace/x86: Load ftrace_ops in parameter not the variable
 holding it
References: <20131113152004.459787f9@gandalf.local.home>
In-Reply-To: <20131113152004.459787f9@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2013 12:20 PM, Steven Rostedt wrote:
> 
> Function tracing callbacks expect to have the ftrace_ops that registered it
> passed to them, not the address of the variable that holds the ftrace_ops
> that registered it.
> 
> Use a mov instead of a lea to store the ftrace_ops into the parameter
> of the function tracing callback.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

This looks like an urgent fix, am I correct?

	-hpa


