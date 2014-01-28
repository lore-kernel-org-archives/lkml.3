Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762AbaA1Cst (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 21:48:49 -0500
Received: from mga02.intel.com ([134.134.136.20]:56517 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753347AbaA1Css (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 21:48:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,733,1384329600"; 
   d="scan'208";a="445581533"
Message-ID: <52E7193C.8050801@intel.com>
Date: Tue, 28 Jan 2014 10:43:08 +0800
From: Ren Qiaowei <qiaowei.ren@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/4] x86, mpx: extend siginfo structure to include
 bound violation information
References: <1390727338-20487-1-git-send-email-qiaowei.ren@intel.com> <1390727338-20487-5-git-send-email-qiaowei.ren@intel.com> <52E6D67A.8050409@amacapital.net>
In-Reply-To: <52E6D67A.8050409@amacapital.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2014 05:58 AM, Andy Lutomirski wrote:
> On 01/26/2014 01:08 AM, Qiaowei Ren wrote:
> (Why on earth does Intel not expose this stuff in cr2 or an MSR or
> something?)
>

I guess it is due to some design reason.

Thanks,
Qiaowei

