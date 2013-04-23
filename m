Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692Ab3DWPRx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 11:17:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59845 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756678Ab3DWPRw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 11:17:52 -0400
Message-ID: <5176A5F7.6000609@zytor.com>
Date: Tue, 23 Apr 2013 08:17:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
CC: arjan@infradead.org, james.hogan@imgtec.com, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com
Subject: Re: [PATCH] x86_32: Fix module version table mismatch.
References: <CAHp75VdDwh0wgCWrVDcPps1C2qfdDZra15y9BQvzfWHzSMqbWA@mail.gmail.com> <CAHp75Vfh6Bpk4j3crVEAo3UtJEqpyucbQw+AzJvO85uRJ6gVgg@mail.gmail.com> <201304222326.IJB21395.FOtVJFHFQMOOSL@I-love.SAKURA.ne.jp> <201304232140.FGF73904.QJOFOVtHFFMSOL@I-love.SAKURA.ne.jp>
In-Reply-To: <201304232140.FGF73904.QJOFOVtHFFMSOL@I-love.SAKURA.ne.jp>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2013 05:40 AM, Tetsuo Handa wrote:
>  
> -#define memcmp __builtin_memcmp
> +int memcmp(const void *cs, const void *ct, size_t count);
>  

Yuck.  I really don't like this option unless it truly can't be
avoided... it might be a fix for 3.9/stable but a better way to do this
would be much more appreciated.

	-hpa


