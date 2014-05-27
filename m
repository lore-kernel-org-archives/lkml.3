Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085AbaE0SWL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 14:22:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:46618 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911AbaE0SWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 14:22:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,921,1392192000"; 
   d="scan'208";a="518500637"
Message-ID: <5384D73C.2030109@intel.com>
Date: Tue, 27 May 2014 11:19:40 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Jet Chen <jet.chen@intel.com>, Miklos Szeredi <mszeredi@suse.cz>
CC: Fengguang Wu <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org
Subject: Re: [vfs] 662aa027bda: -7.2% will-it-scale.scalability
References: <5384B634.7080902@intel.com>
In-Reply-To: <5384B634.7080902@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2014 08:58 AM, Jet Chen wrote:
> 9f498c77b4332b4  662aa027bdaa082aa3dd21886
> ---------------  -------------------------
>       0.63 ~ 0%      -7.2%       0.58 ~ 0%  TOTAL will-it-scale.scalability
>   12861563 ~ 0%      -1.1%   12715565 ~ 0%  TOTAL will-it-scale.per_process_ops

There's something funky here.

What are the numbers being factored in to 'will-it-scale.scalability'
and 'will-it-scale.per_process_ops'?  Could you share the raw csv's that
will-it-scale generated?

Since 'per_process_ops' is only off by 1.1%, my suspicion is that some
consistent skew on the 1-process case is getting magnified in to the
scalability number.
