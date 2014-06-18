Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499AbaFRAeA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 20:34:00 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:40686 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357AbaFRAd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 20:33:59 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: acme@kernel.org, artagnon@gmail.com, jolsa@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] perf timechart: add more options to IO mode
References: <1402412694-5996-1-git-send-email-stfomichev@yandex-team.ru>
	<1402412694-5996-4-git-send-email-stfomichev@yandex-team.ru>
	<87lht39bx0.fsf@sejong.aot.lge.com>
	<20140616061522.GB9394@stfomichev-desktop.yandex.net>
Date: Wed, 18 Jun 2014 09:33:57 +0900
In-Reply-To: <20140616061522.GB9394@stfomichev-desktop.yandex.net> (Stanislav
	Fomichev's message of "Mon, 16 Jun 2014 10:15:22 +0400")
Message-ID: <87oaxr839m.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jun 2014 10:15:22 +0400, Stanislav Fomichev wrote:
>> It's in nano-second unit, right?  If so, it's very unconvenient for user
>> to specify.  Maybe we could support to parse unit (s, ms, us, ...) also.
> Yes, it's nano-second. I didn't want to limit it to ms, because I
> still want to be able to specify ns. I think it's a good idea to support
> parsing units. Can I use OPT_CALLBACK or there is a better way to do that
> (I couldn't find any similar conversions in perf)?

Please use OPT_CALLBACK.

Thanks,
Namhyung
