Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350AbaCDCpn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 21:45:43 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:65077 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756328AbaCDCpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 21:45:40 -0500
MIME-Version: 1.0
In-Reply-To: <1393900936-22977-1-git-send-email-namhyung@kernel.org>
References: <1393900936-22977-1-git-send-email-namhyung@kernel.org>
From: Namhyung Kim <namhyung@kernel.org>
Date: Tue, 4 Mar 2014 11:45:20 +0900
X-Google-Sender-Auth: HmB_sfwSMic-3QQWHMs_TmFV-js
Message-ID: <CAM9d7cgE0+H6Kh9zxE-cBwc8aJh1=fUBMu1V4is=4MgpomxHdg@mail.gmail.com>
Subject: Re: [RFC 00/10] perf report: Add -F option for specifying output fields
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forgot to mention, this patchset is based on my percentage-v6 patchset.

https://lkml.org/lkml/2014/3/2/236

Thanks,
Namhyung
