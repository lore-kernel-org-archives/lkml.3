Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969AbaIXUWm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 16:22:42 -0400
Received: from outbound-smtp01.blacknight.com ([81.17.249.7]:47511 "EHLO
	outbound-smtp01.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751505AbaIXUWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 16:22:41 -0400
Message-ID: <54232807.20909@nexus-software.ie>
Date: Wed, 24 Sep 2014 21:22:31 +0100
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
Reply-To: pure.logic@nexus-software.ie
Organization: Nexus Software
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, mingo@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        stable@vger.kernel.org, bp@alien8.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/platform] x86/intel/quark: Switch off CR4.PGE so TLB
 flush uses CR3 instead
References: <1411514784-14885-1-git-send-email-pure.logic@nexus-software.ie> <tip-ee1b5b165c0a2f04d2107e634e51f05d0eb107de@git.kernel.org> <5422E8D0.5080705@zytor.com> <5422EA13.1080706@nexus-software.ie> <5422EC30.10206@nexus-software.ie> <54231088.8030000@zytor.com> <542310E3.90803@zytor.com>
In-Reply-To: <542310E3.90803@zytor.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> Well, we need a comment at least.
>>
>
> And certainly we don't need an if/else as we can just do it.
>
> 	-hpa

OK.

No problem.

BOD
