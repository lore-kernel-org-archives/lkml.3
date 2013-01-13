Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998Ab3AMWCS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 17:02:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58559 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755491Ab3AMWCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 17:02:16 -0500
Message-ID: <50F32EE3.8010705@suse.cz>
Date: Sun, 13 Jan 2013 23:02:11 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Makefile: Make checkstack work with O= builds
References: <1356141525-25162-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1356141525-25162-1-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.12.2012 02:58, Stephen Boyd wrote:
> The vmlinux doesn't always live in the same directory as the
> source files and so 'make O=obj checkstack' fails with a missing
> vmlinux file. Fix checkstack so that this is possible.

It works for me even without your patch. With O=<dir>, a second make is
run in <dir>, so $(objtree) is equivalent to . for the top-level
Makefile. Can you post the exact command your run and the error message
you get?

Thanks,
Michal
