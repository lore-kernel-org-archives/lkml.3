Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150Ab3HGGTS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 02:19:18 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:48280 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932091Ab3HGGSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 02:18:31 -0400
X-AuditID: 9c930197-b7b17ae000000a07-95-5201e6b5a77e
From: Namhyung Kim <namhyung@kernel.org>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: <linux-kernel@vger.kernel.org>, acme@ghostprotocols.net,
        a.p.zijlstra@chello.nl, jolsa@redhat.com
Subject: Re: [PATCH v2 2/2] perf tests: Add tests of new pinned modifier
References: <1375795686-4226-1-git-send-email-michael@ellerman.id.au>
	<1375795686-4226-2-git-send-email-michael@ellerman.id.au>
Date: Wed, 07 Aug 2013 15:18:29 +0900
In-Reply-To: <1375795686-4226-2-git-send-email-michael@ellerman.id.au>
	(Michael Ellerman's message of "Tue, 6 Aug 2013 23:28:06 +1000")
Message-ID: <877gfyyqfe.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  6 Aug 2013 23:28:06 +1000, Michael Ellerman wrote:
> Add a negative test to test__checkevent_pmu_events() to get lots of
> coverage of the negative case, ie. when the modifier is not specified.
>
> Add a test of a single event, and of the group case.

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung
