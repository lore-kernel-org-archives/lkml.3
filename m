Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622Ab3B1KAS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 05:00:18 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:50018 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163Ab3B1KAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 05:00:14 -0500
X-AuditID: 9c930179-b7b61ae000004061-f6-512f2aabc051
From: Namhyung Kim <namhyung@kernel.org>
To: Roberto Vitillo <ravitillo@lbl.gov>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org,
        mingo@redhat.com, acme@ghostprotocols.net
Subject: Re: [PATCH] perf: add callgrind conversion tool
References: <CA+BNSkX-2NhJmf0b26Bmf-bK_dFnGE_NOR-F9p2MDpZTuScHpg@mail.gmail.com>
Date: Thu, 28 Feb 2013 19:00:10 +0900
In-Reply-To: <CA+BNSkX-2NhJmf0b26Bmf-bK_dFnGE_NOR-F9p2MDpZTuScHpg@mail.gmail.com>
	(Roberto Vitillo's message of "Wed, 27 Feb 2013 00:26:33 +0100")
Message-ID: <87d2vksqqd.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roberto,

On Wed, 27 Feb 2013 00:26:33 +0100, Roberto Vitillo wrote:
> The proposed patch adds the convert tool to perf which allows to convert a
> perf.data file to a callgrind data file which can subsequently be displayed
> with kcachegrind. Callgraphs are not supported.
>
> In order to speed up the converter I am not piping to addr2line, this
> means that
> the code depends on libbfd. Considering that perf doesn't strictly depend on
> libbfd my question is if it would be feasible to add that requirement.

You can make it optional, disables 'convert' command when missing.

I didn't read your code in detail yet, will do if I have free time soon.

Thanks,
Namhyung
