Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984Ab3IMX1I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 19:27:08 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:55515 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755295Ab3IMX1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 19:27:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 000/228] CPUFreq: cleanup stuff for 3.13
Date: Sat, 14 Sep 2013 01:38:08 +0200
Message-ID: <3040696.n8OU0605eG@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, September 13, 2013 06:29:06 PM Viresh Kumar wrote:
> This is my biggest patchset ever and it might not happen again in my entire
> career. I hope I haven't screwed up here :)
> 
> CPUFreq cleanup patches are ready to hit linux-next (I hope it doesn't turn out
> into horror stories, where it broke all possible architectures where Linux runs
> :))
> 
> Most of these are build tested only, Also done by: Fengguang Wu's build bot.
> 
> All of these were sent separately in smaller patchsets earlier and now merged
> together as a single set. Some parts are reviewed by platform maintainers and
> their Acks are included in the patches (Sorry if I missed any)..

I believe I asked you to send this stuff in pieces.

In any case, there's no way I'll apply this all at once and I'm not going to
pull it all at once either.

Thanks,
Rafael

