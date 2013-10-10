Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab3JJGHu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 02:07:50 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:59643 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497Ab3JJGHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 02:07:40 -0400
X-AuditID: 9c930179-b7c78ae000003065-58-525644278c20
From: Namhyung Kim <namhyung@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 26/52] tools/perf/build: Split out feature check: 'libbfd'
References: <1381227082-22039-1-git-send-email-mingo@kernel.org>
	<1381227082-22039-27-git-send-email-mingo@kernel.org>
Date: Thu, 10 Oct 2013 15:07:35 +0900
In-Reply-To: <1381227082-22039-27-git-send-email-mingo@kernel.org> (Ingo
	Molnar's message of "Tue, 8 Oct 2013 12:10:56 +0200")
Message-ID: <871u3tk6ag.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  8 Oct 2013 12:10:56 +0200, Ingo Molnar wrote:
> +test-libbfd:
> +	$(BUILD) -DPACKAGE='perf' -DPACKAGE=perf -lbfd -ldl

Duplicate PACKAGE definitions.  It seems only one is needed and it
should look like a normal C string like -DPACKAGE='"perf"' IMHO.

Thanks,
Namhyung
