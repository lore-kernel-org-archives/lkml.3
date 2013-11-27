Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871Ab3K0JVi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 04:21:38 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:46319 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab3K0JVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 04:21:34 -0500
MIME-Version: 1.0
In-Reply-To: <20131126120254.GI1267@krava.brq.redhat.com>
References: <1385274025-30282-1-git-send-email-artagnon@gmail.com>
 <1385274025-30282-4-git-send-email-artagnon@gmail.com> <20131126120254.GI1267@krava.brq.redhat.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Wed, 27 Nov 2013 14:50:54 +0530
Message-ID: <CALkWK0mTdiEtyCMMFEqXFVa0msY0kbAtSvSN2e5CBE_urrS1kA@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] perf diff: generalize hpp__color_delta for -c
To: Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Olsa wrote:
> I think it'd be better to have just one switch for
> comparison_method and do all the processing within

Okay, will fix in the next iteration.
