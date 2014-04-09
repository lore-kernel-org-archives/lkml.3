Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbaDIF0p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 01:26:45 -0400
Received: from mga11.intel.com ([192.55.52.93]:43230 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779AbaDIF0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 01:26:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,823,1389772800"; 
   d="scan'208";a="509851575"
Message-ID: <5344DA05.5070204@intel.com>
Date: Wed, 09 Apr 2014 13:26:29 +0800
From: Jet Chen <jet.chen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Alessandro Rubini <rubini@gnudd.com>
CC: gregkh@linuxfoundation.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, fengguang.wu@intel.com
Subject: Re: [FMC] BUG: scheduling while atomic: swapper/1/0x10000002
References: <5344BF60.5050300@intel.com> <20140409050843.GA18949@mail.gnudd.com>
In-Reply-To: <20140409050843.GA18949@mail.gnudd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2014 01:08 PM, Alessandro Rubini wrote:
> Hello.
> Thank you for the report.
> 
> I'm at a conference and I fear I won't be able to test myself in the
> next days, but I think this is already fixed (it is part of
> the "misc_register" call path, so it's the same problem).
> 
> The fix is commit v3.11-rc2-11-g783c2fb
> 
>    783c2fb FMC: fix locking in sample chardev driver
> 
> This commit, however, is not part of v3.11 and I think this is why you
> are finding the problem in the v3.10..v3.11 interval.
> 
> thank you again
> /alessandro
> 

I find commit 783c2fb FMC: fix locking in sample chardev driver. I will help to test it.
