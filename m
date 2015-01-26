Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbbAZCNw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 21:13:52 -0500
Received: from mga09.intel.com ([134.134.136.24]:59838 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236AbbAZCNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 21:13:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,465,1418112000"; 
   d="scan'208";a="675789920"
Message-ID: <54C5A2D9.8080705@linux.intel.com>
Date: Mon, 26 Jan 2015 10:13:45 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sam Ravnborg <sam@ravnborg.org>, Kirill Tkhai <tkhai@yandex.ru>
CC: Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [Resend Patch v4 00/16] Kill SMP single function call interrupt
References: <1421991416-20297-1-git-send-email-jiang.liu@linux.intel.com> <alpine.DEB.2.11.1501242027090.5526@nanos>
In-Reply-To: <alpine.DEB.2.11.1501242027090.5526@nanos>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2015/1/25 3:28, Thomas Gleixner wrote:
> On Fri, 23 Jan 2015, Jiang Liu wrote:
> 
>>  38 files changed, 65 insertions(+), 268 deletions(-)
> 
> Nice cleanup. If nobody yells, I'm going to route it through tip.
Hi Thomas,
	We need explicitly ACKs from SPARC/SPARC64 maintainers
for patch 9 and 10. SPARC assembler has some advanced concept
"defer slot", I'm not sure I have done it in the right way.
Thanks!
Gerry
> 
> Thanks,
> 
> 	tglx
> 
