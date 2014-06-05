Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751694AbaFEQGn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 12:06:43 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:50811 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbaFEQGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 12:06:41 -0400
MIME-Version: 1.0
Date: Thu, 5 Jun 2014 18:06:41 +0200
Message-ID: <CABPqkBTz7dBFGKGE5Ng8LwB=HQV_VQfhGRyWDC0ofnSjx2r3Vw@mail.gmail.com>
Subject: [BUG] perf record: pipe mode still broken
From: Stephane Eranian <eranian@google.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

Somehow, I thought you had written a fix to avoid the problem below.
But when I try with tip.git, the problem is still there.
Could you push your fix ASAP.

Thanks.

$ perf record -o - noploop 2 |  perf inject -b |  perf report -i -
# To display the perf.data header info, please use
--header/--header-only options.
#
noploop for 2 seconds
0x1bd0 [0x28]: failed to process type: 9
