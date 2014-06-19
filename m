Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754AbaFSAap (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 20:30:45 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:48192 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaFSAao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 20:30:44 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: acme@kernel.org, artagnon@gmail.com, jolsa@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] perf timechart: implement IO mode
References: <1402412694-5996-1-git-send-email-stfomichev@yandex-team.ru>
	<1402412694-5996-2-git-send-email-stfomichev@yandex-team.ru>
	<87ppif9c3y.fsf@sejong.aot.lge.com>
	<20140616060804.GA9394@stfomichev-desktop.yandex.net>
	<87sin383cw.fsf@sejong.aot.lge.com>
	<20140618090034.GC15620@stfomichev-desktop.yandex.net>
Date: Thu, 19 Jun 2014 09:30:35 +0900
In-Reply-To: <20140618090034.GC15620@stfomichev-desktop.yandex.net> (Stanislav
	Fomichev's message of "Wed, 18 Jun 2014 13:00:34 +0400")
Message-ID: <87fvj191w4.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stanislav,

On Wed, 18 Jun 2014 13:00:34 +0400, Stanislav Fomichev wrote:
>> > Can you somehow share your perf.data with me? I'll check what's going
>> > on.
>> 
>> https://git.kernel.org/cgit/linux/kernel/git/namhyung/linux-perf.git/plain/tools/perf/perf.timechart.data?h=perf/tmp
> Hm, I don't see any issue with your data, I can see dd disk io and firefox polls.
> I attached output.png, but it has some artifacts (I used imagemagick to convert
> it); if I use Inkscape to view SVG, I don't see any artifacts (maybe
> there is a problem, but another one).
>
> Do you get different picture (empty process bars) if you run it on your side?
> If you do, then I'm puzzled...

Hmm.. it looks like an unrelated issue.  I can see the bars in inkscape,
but still see empty grey bars in firefox.

Thanks,
Namhyung
