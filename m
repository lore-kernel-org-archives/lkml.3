Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937Ab3KGHHI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 02:07:08 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:61773 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab3KGHHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 02:07:05 -0500
X-AuditID: 9c93016f-b7bb9ae000001e30-ca-527b3c173868
From: Namhyung Kim <namhyung@kernel.org>
To: Rodrigo Campos <rodrigo@sdfg.com.ar>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org,
        mingo@redhat.com, acme@ghostprotocols.net
Subject: Re: [PATCH] perf: Remove unneeded include
References: <1383776454-10595-1-git-send-email-rodrigo@sdfg.com.ar>
Date: Thu, 07 Nov 2013 16:07:03 +0900
In-Reply-To: <1383776454-10595-1-git-send-email-rodrigo@sdfg.com.ar> (Rodrigo
	Campos's message of "Wed, 6 Nov 2013 22:20:54 +0000")
Message-ID: <87iow4wuzs.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rodrigo,

On Wed,  6 Nov 2013 22:20:54 +0000, Rodrigo Campos wrote:
> There is no point in sort.h including itself.
>
> The include was added when the file was created, in commit "perf tools: Create
> util/sort.and use it" (dd68ada2d) and added a include to "sort.h" in lot of
> files (all the files that started using the file). It was probably added by
> mistake on sort.h too.

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung
