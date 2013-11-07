Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592Ab3KGQZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 11:25:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41825 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945Ab3KGQZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 11:25:26 -0500
Message-ID: <527BBEDD.60407@zytor.com>
Date: Thu, 07 Nov 2013 08:25:01 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Marek Majkowski <marek@cloudflare.com>,
        Jiri Slaby <jslaby@suse.cz>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Wrong symbol resolved for RIP on OOPS/BUG
References: <1383767997-20765-1-git-send-email-marek@cloudflare.com> <20131107075448.GA31926@gmail.com>
In-Reply-To: <20131107075448.GA31926@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2013 11:54 PM, Ingo Molnar wrote:
> 
> There's a recent commit from Jiri Slaby that I think tries to address the 
> same problem:
> 
>   8d4c812a3e5f x86/dumpstack: Fix printk_address for direct addresses
> 
> You can find it in the -tip tree:
> 
>   git remote add tip git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git
> 

The only difference seems to be in the handling of the "reliable" flag.

I am wondering if we shouldn't promote this patch to urgent/stable,
though, since misleading oops messages could be very disruptive.

	-hpa

