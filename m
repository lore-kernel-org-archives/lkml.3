Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682AbaCREZx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 00:25:53 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:36508 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbaCREZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 00:25:52 -0400
MIME-Version: 1.0
In-Reply-To: <CAM9d7ch0xHO4S6drn_G2CELTD6G51ADE+XvvSJw5Jid2Dy7Khw@mail.gmail.com>
References: <1394437440-11609-1-git-send-email-namhyung@kernel.org>
 <1394437440-11609-3-git-send-email-namhyung@kernel.org> <20140317200832.GE31482@ghostprotocols.net>
 <CAM9d7ch0xHO4S6drn_G2CELTD6G51ADE+XvvSJw5Jid2Dy7Khw@mail.gmail.com>
From: Namhyung Kim <namhyung@kernel.org>
Date: Tue, 18 Mar 2014 13:25:31 +0900
X-Google-Sender-Auth: abtfP34KH4f-p06w-W1t5P2z2Ow
Message-ID: <CAM9d7ci-8w7z-qgH8Mw+_csqwSNh+1GcO5zuPMSoH8jV+sO0jQ@mail.gmail.com>
Subject: Re: [PATCH 2/9] perf tools: Count periods of filtered entries separately
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 1:19 PM, Namhyung Kim <namhyung@kernel.org> wrote:

> It's because thread__find_addr_map() clears al->filtered, so filtering
> with -d option won't work.  Maybe we can move initialization of the
> al->filtered upto this function.

Oh, I meant the -c/--comms option actually :)

Thanks,
Namhyung
