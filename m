Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102Ab3CKIIZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 04:08:25 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:48044 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654Ab3CKIIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 04:08:24 -0400
X-AuditID: 9c930179-b7c78ae000000e4b-16-513d90f45ead
From: Namhyung Kim <namhyung@kernel.org>
To: Jack Mitchell <ml@communistcode.co.uk>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jack Mitchell <jack.mitchell@dbbroadcast.co.uk>
Subject: Re: [PATCH] libtraceevent: remove hard coded include to /usr/local/include in Makefile
References: <1362741712-21308-1-git-send-email-ml@communistcode.co.uk>
Date: Mon, 11 Mar 2013 17:08:20 +0900
In-Reply-To: <1362741712-21308-1-git-send-email-ml@communistcode.co.uk> (Jack
	Mitchell's message of "Fri, 8 Mar 2013 11:21:52 +0000")
Message-ID: <87ip4yqryj.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  8 Mar 2013 11:21:52 +0000, Jack Mitchell wrote:
> From: Jack Mitchell <jack.mitchell@dbbroadcast.co.uk>
>
> having /usr/local/include hardcoded into the makefile is not necessary as this
> is automatically included by GCC. It also infects cross-compile builds with the
> host systems includes.

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung
