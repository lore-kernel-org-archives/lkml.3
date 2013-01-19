Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263Ab3ASAmU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 19:42:20 -0500
Received: from mga11.intel.com ([192.55.52.93]:48039 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753253Ab3ASAmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 19:42:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,495,1355126400"; 
   d="scan'208";a="278868086"
Message-ID: <50F9EBEA.9020805@linux.intel.com>
Date: Fri, 18 Jan 2013 16:42:18 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Andres Salomon <dilinger@queued.net>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        David Woodhouse <dwmw2@infradead.org>, Vivek Goyal <vgoyal@in.ibm.com>,
        Yinghai Lu <yhlu.kernel@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        techteam@lists.laptop.org
Subject: Re: [RFC PATCH] x86-32: Start out eflags and cr4 clean
References: <87sjaaj3cx.fsf@xmission.com> <1348529239-17943-1-git-send-email-hpa@linux.intel.com> <20121010125927.0968dd8b@dev.queued.net> <20130118164043.29674d75@dev.queued.net>
In-Reply-To: <20130118164043.29674d75@dev.queued.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2013 04:40 PM, Andres Salomon wrote:
> Bad news on this patch; I've been told that it breaks booting on an
> XO-1.5.  Does anyone from OLPC know why yet?

What are the settings of CR0 and CR4 on kernel entry on XO-1.5?

	-hpa


