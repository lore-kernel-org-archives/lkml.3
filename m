Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673Ab3KSSYo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 13:24:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51098 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236Ab3KSSYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 13:24:43 -0500
Message-ID: <528BACCB.1090604@zytor.com>
Date: Tue, 19 Nov 2013 10:24:11 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Joe Perches <joe@perches.com>
CC: Ingo Molnar <mingo@kernel.org>,
        =?UTF-8?B?Sm9oYW5uZXMgTMO2dGhiZXJn?= <johannes@kyriasis.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: boot: Fix mixed indentation in a20.c
References: <1384797009-4096-1-git-send-email-johannes@kyriasis.com> <528ACB6A.1040809@zytor.com> <20131119072241.GB32478@gmail.com> <20131119103408.GA3640@pd.tnic> <1384883323.17783.35.camel@joe-AO722> <20131119182306.GD3515@pd.tnic>
In-Reply-To: <20131119182306.GD3515@pd.tnic>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2013 10:23 AM, Borislav Petkov wrote:
> On Tue, Nov 19, 2013 at 09:48:43AM -0800, Joe Perches wrote:
>> git diff -w and git blame -w both ignore whitespace changes and can
>> help in tracking down actual modifications.
> 
> That's not the point - I don't want those commits there getting in the
> way.
> 
> If it
> 
>  * doesn't fix a real bug,
>  * doesn't improve code generation
>  * doesn't have any other positive effect on the resulting object code
> 
> then it doesn't need to be there.
> 
> Whitespace jerking off doesn't belong in the kernel.
> 

I'll take a proper cleanup, but just whitespace... just pointless churn.

	-hpa

