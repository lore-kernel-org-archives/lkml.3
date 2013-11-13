Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759749Ab3KMSkt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 13:40:49 -0500
Received: from mga09.intel.com ([134.134.136.24]:40816 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755054Ab3KMSkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 13:40:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="408290921"
Message-ID: <5283C7A8.2010902@linux.intel.com>
Date: Wed, 13 Nov 2013 10:40:40 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@kernel.org>
CC: hpa@zytor.com, linux-kernel@vger.kernel.org, keescook@chromium.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/kaslr] x86, kaslr: Provide randomness functions
References: <1381450698-28710-4-git-send-email-keescook@chromium.org> <tip-5bfce5ef55cbe78ee2ee6e97f2e26a8a582008f3@git.kernel.org> <20131111182046.GA14961@gmail.com> <20131113181600.GA6160@amd.pavel.ucw.cz>
In-Reply-To: <20131113181600.GA6160@amd.pavel.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2013 10:16 AM, Pavel Machek wrote:
> 
> If it is not performance critical, why not use "/dev/random"
> infrastructure?
> 

Because it doesn't exist yet?

	-hpa

