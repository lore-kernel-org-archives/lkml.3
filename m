Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804AbbAZUFR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 15:05:17 -0500
Received: from mga14.intel.com ([192.55.52.115]:47219 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756648AbbAZUFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 15:05:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,470,1418112000"; 
   d="scan'208";a="656729685"
Message-ID: <54C69DF9.1090702@intel.com>
Date: Mon, 26 Jan 2015 12:05:13 -0800
From: "H. Peter Anvin" <h.peter.anvin@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Ross Zwisler <ross.zwisler@linux.intel.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v2 0/2] add support for new persistent memory instructions
References: <1422045628-16225-1-git-send-email-ross.zwisler@linux.intel.com>	 <54C2D34D.7010709@intel.com> <1422301899.13382.2.camel@theros.lm.intel.com>
In-Reply-To: <1422301899.13382.2.camel@theros.lm.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2015 11:51 AM, Ross Zwisler wrote:
> 
> This is fine, but now you've got two fences in a row.  Another slightly more
> messy choice would be to include the fence in the pcommit assembly, so
> you either get pcommit + sfence or a pair of NOPs.
> 

If that is the required usage pattern, it should be part of the clwb()
inline at least.

	-hpa

