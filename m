Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736AbaEBJ3I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 05:29:08 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:49287 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbaEBJ3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 05:29:05 -0400
Message-ID: <5363655D.6020408@gmail.com>
Date: Fri, 02 May 2014 11:29:01 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: mtk.manpages@gmail.com, Randy Dunlap <rdunlap@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [patch] timer_stats, doc: Readout of /proc/timer_stats doesn't disable
 sampling
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Kerrisk <mtk.manpages@gmail.com>

Some simple testing shows that reading from /proc/timer_stats
does not disable sampling. Looking back over past source code,
it appears that it never did.

Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
