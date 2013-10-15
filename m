Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750826Ab3JOEED (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 00:04:03 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:50255 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab3JOEEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 00:04:02 -0400
X-AuditID: 9c93017d-b7b2eae000005519-8f-525cbeb00d5a
From: Namhyung Kim <namhyung@kernel.org>
To: Felipe Pena <felipensp@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Borislav Petkov <bp@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] tools/perf/util: Fix memory leak in trace-event-info.c
References: <1381794504-4146-1-git-send-email-felipensp@gmail.com>
Date: Tue, 15 Oct 2013 13:04:00 +0900
In-Reply-To: <1381794504-4146-1-git-send-email-felipensp@gmail.com> (Felipe
	Pena's message of "Mon, 14 Oct 2013 20:48:24 -0300")
Message-ID: <877gdfb2of.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Oct 2013 20:48:24 -0300, Felipe Pena wrote:
> Fix for a memory leak on tracing_data_get() function when returning NULL explicitly

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung
