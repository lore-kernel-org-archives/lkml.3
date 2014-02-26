Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849AbaBZBfy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 20:35:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34487 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900AbaBZBfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 20:35:52 -0500
Message-ID: <530D44C2.6040506@zytor.com>
Date: Tue, 25 Feb 2014 17:34:58 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Behan Webster <behanw@converseincode.com>, Dave Jones <davej@redhat.com>,
        mmarek@suse.cz, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        sparse@chrisli.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org,
        torvalds@linux-foundation.org, dwmw2@infradead.org,
        pageexec@freemail.hu,
        =?ISO-8859-1?Q?Jan-Simon_M=F6ller?= <dl9pf@gmx.de>,
        Mark Charlebois <mcharleb@gmail.com>
Subject: Re: [PATCH 2/5] kbuild: LLVMLinux: Adapt warnings for compilation
 with clang
References: <1393376923-21892-1-git-send-email-behanw@converseincode.com> <1393376923-21892-3-git-send-email-behanw@converseincode.com> <20140226011737.GA4564@redhat.com> <530D43E9.6010207@converseincode.com>
In-Reply-To: <530D43E9.6010207@converseincode.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2014 05:31 PM, Behan Webster wrote:
> 
> This are primarily off due to the amount of noise these warnings produce
> at this time (clang produces a LOT of warnings straight out of the box).
> I'd love to eventually turn some of these back on again.
> 

It would also be nice if someone would be willing to look at the sparse
warnings the kernel output -- there are tens of thousands of them it
seems, although some are from header files.

	-hpa


