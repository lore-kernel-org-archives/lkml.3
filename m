Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728Ab3JHIeA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 04:34:00 -0400
Received: from intranet.asianux.com ([58.214.24.6]:33576 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab3JHId4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 04:33:56 -0400
X-Spam-Score: -100.1
Message-ID: <5253C335.5050609@asianux.com>
Date: Tue, 08 Oct 2013 16:32:53 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: josh@freedesktop.org, Paul McKenney <paulmck@linux.vnet.ibm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [Suggestion] kernel/rcutorture.c: about using scnprintf() instead
 of sprintf().
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Maintainers:

In srcu_torture_stats(), if cpus are more than 1K, the PAGE_SIZE will
not be enough.

In rcu_torture_printk(), the 'page' maximized size is 4096, it has a
function pointer for printing, which not tell its maximized length.


Welcome any additional suggestions or completions.


Thanks.
-- 
Chen Gang
