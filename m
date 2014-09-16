Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbaIPONl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 10:13:41 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:46926 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393AbaIPONk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 10:13:40 -0400
Message-ID: <54184580.8040305@oracle.com>
Date: Tue, 16 Sep 2014 10:13:20 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Andrew Morton <akpm@linuxfoundation.org>
Subject: Processes hang inside kernel built with gcc5
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

When booting a -next kernel with gcc5 it seems that some processes will hang
on execution, while others will run just fine.

I wasn't able to find exactly what part of the kernel causes this issue, but
I've bisected gcc and found the offending commit:
https://gcc.gnu.org/viewcvs/gcc?view=revision&revision=213753

I've reported this issue to GCC (https://gcc.gnu.org/bugzilla/show_bug.cgi?id=63279).


Thanks,
Sasha
