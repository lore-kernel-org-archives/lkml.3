Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752Ab3C0HXb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 03:23:31 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:46731 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221Ab3C0HXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 03:23:30 -0400
X-AuditID: 9c930179-b7c78ae000000e4b-c9-51529e6f34ad
From: Namhyung Kim <namhyung@kernel.org>
To: Roberto Vitillo <ravitillo@lbl.gov>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org,
        mingo@redhat.com, acme@ghostprotocols.net
Subject: Re: [PATCH v2] perf: add callgrind conversion tool
References: <CA+BNSkWCX2TVYU26A7qHFqr6F5Pw44wy76BSfnS5MnVDKGCh9w@mail.gmail.com>
Date: Wed, 27 Mar 2013 16:23:27 +0900
In-Reply-To: <CA+BNSkWCX2TVYU26A7qHFqr6F5Pw44wy76BSfnS5MnVDKGCh9w@mail.gmail.com>
	(Roberto Vitillo's message of "Tue, 26 Mar 2013 12:14:49 -0700")
Message-ID: <87a9ppgvbk.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roberto,

On Tue, 26 Mar 2013 12:14:49 -0700, Roberto Vitillo wrote:
> The proposed patch adds the convert tool to perf which allows to convert a
> perf.data file to a set of callgrind data files which can subsequently be
> displayed with kcachegrind.
>
> Note that the code may trigger the following bug in libbfd:
> http://sourceware.org/bugzilla/show_bug.cgi?id=15106

Does it now support call graph too?  Great if so!

Anyway, I suggest that splitting patch to two - one for addr2line and
another for actual 'convert' tool.  I think we *can* use the tool
without libbfd (but with external addr2line binary or even with no line
number information).

And it seems there's some linewraps.

Thanks,
Namhyung
