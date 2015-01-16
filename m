Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669AbbAPT1t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 14:27:49 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:62074 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbbAPT1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 14:27:48 -0500
Message-ID: <54B9662A.6080400@gmail.com>
Date: Fri, 16 Jan 2015 20:27:38 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: mtk.manpages@gmail.com, Darren Hart <dvhart@linux.intel.com>,
        lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 0/2] futex: Minor fixes to doc and code
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Thomas,

While working on revisions to the futex(2) man page, I noticed
a couple of source files that could be improved. In one Doc file,
important constants are misnamed, so that grepping won't find
useful information. And in the futex.c code, the argument handling
in futex_lock_pi() is a little confused.

Thanks,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
