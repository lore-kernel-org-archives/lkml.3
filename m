Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063AbaBZVT7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 16:19:59 -0500
Received: from mga02.intel.com ([134.134.136.20]:38264 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466AbaBZVT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 16:19:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,550,1389772800"; 
   d="scan'208";a="490395683"
Message-ID: <530E5A7D.9060902@intel.com>
Date: Wed, 26 Feb 2014 13:19:57 -0800
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Qiaowei Ren <qiaowei.ren@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/3] x86, mpx: add documentation on Intel MPX
References: <1393162071-23995-1-git-send-email-qiaowei.ren@intel.com> <1393162071-23995-2-git-send-email-qiaowei.ren@intel.com>
In-Reply-To: <1393162071-23995-2-git-send-email-qiaowei.ren@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2014 05:27 AM, Qiaowei Ren wrote:
> +The other case that generates a #BR is when a BNDSTX instruction
> +attempts to save bounds to a BD entry marked as invalid. This is
> +an indication that no BT exists for this entry. In this case the
> +fault handler will allocate a new BT.

Hi Qiaowei,

Can you make an effort to move these comments over to the code?  The
bounds-table allocation function is a much more appropriate place for
this text than the Documentation/ file.
