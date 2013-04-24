Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483Ab3DXAw7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 20:52:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35750 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754535Ab3DXAw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 20:52:58 -0400
Message-ID: <51772CD3.3040405@zytor.com>
Date: Tue, 23 Apr 2013 17:52:35 -0700
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
> Commit a4b6a77b "module: fix symbol versioning with symbol prefixes" broke
> loading of net/ipv6/ipv6.ko built with CONFIG_MODVERSIONS=y for x86_32.

This really does seem to be the offending commit, although I'm still
confused how the heck that is possible.

	-hpa


