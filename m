Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162413AbaDCHFH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 03:05:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:61185 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162382AbaDCHFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 03:05:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,784,1389772800"; 
   d="scan'208";a="513903822"
Message-ID: <533D07BE.8070202@linux.intel.com>
Date: Thu, 03 Apr 2014 15:03:26 +0800
From: "Li, Aubrey" <aubrey.li@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "Du, ChangbinX" <changbinx.du@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [HELP] How to use ftrace to learn how a function is ivoked?
References: <0C18FE92A7765D4EB9EE5D38D86A563A01AA980B@SHSMSX103.ccr.corp.intel.com>
In-Reply-To: <0C18FE92A7765D4EB9EE5D38D86A563A01AA980B@SHSMSX103.ccr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/4/3 14:36, Du, ChangbinX wrote:
> Hi, All,
> I have a question for ftrace usage. It is that if I have a function A, then I want to 
> know how function A is ivoked?
> I know ftrace can show me what sub-functions that A called by below steps:
> 	# echo function_graph > current_tracer
> 　　# echo function_A > set_graph_function
> 	# cat trace
> Then a call stack will show what functions A has called. But sometimes I want to 
> know how A is called. Is there a method to do this? Please help me!

dump_stack(), kprobe, AFAIK.

Thanks,
-Aubrey
