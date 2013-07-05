Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933721Ab3GECqt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 22:46:49 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:49484 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757031Ab3GECqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 22:46:48 -0400
X-AuditID: 9c93017d-b7c1bae0000060c3-df-51d633923e19
From: Namhyung Kim <namhyung@kernel.org>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] Minor perf completion improvements
References: <1372941691-14684-1-git-send-email-artagnon@gmail.com>
Date: Fri, 05 Jul 2013 11:46:41 +0900
In-Reply-To: <1372941691-14684-1-git-send-email-artagnon@gmail.com> (Ramkumar
	Ramachandra's message of "Thu, 4 Jul 2013 18:11:24 +0530")
Message-ID: <874nc9zpta.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  4 Jul 2013 18:11:24 +0530, Ramkumar Ramachandra wrote:
> Hi,
>
> So I just started using perf, and noticed the accompanying completion
> script. Having dabbled with git.git's completion script a bit, I
> thought I should contribute what I learnt from it.
>
> [6/7] is the meat of the series, and the preceding patches work
> towards the same goal: to strip dependency on the bash-completion
> package.

So the whole point of this patchset is removing dependency, and no
functional change, right?

It'd be great if the completion script supports multiple events
separated by comma esp. in a group syntax (i.e. surrounded be a pair of
curly braces: -e '{cache-references,cache-misses}').  Could you take a
look at that if possible?

Thanks,
Namhyung
