Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964Ab3HTDii (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 23:38:38 -0400
Received: from intranet.asianux.com ([58.214.24.6]:5091 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab3HTDih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 23:38:37 -0400
X-Spam-Score: -101.1
Message-ID: <5212E481.9080204@asianux.com>
Date: Tue, 20 Aug 2013 11:37:37 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        Mel Gorman <mgorman@suse.de>, riel@redhat.com
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] kernel/sysctl.c: about the return value after fail call
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 1 for bug fix: check return value after call proc_put_char() in
__do_proc_doulongvec_minmax()

Patch 2 for simplify code : Simplify code for C code readers.


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 kernel/sysctl.c |   30 +++++++++++++++++-------------
 1 files changed, 17 insertions(+), 13 deletions(-)
