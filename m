Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362AbaEWNOs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 09:14:48 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:51235 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbaEWNOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 09:14:46 -0400
Message-ID: <537F49C2.3000304@gmail.com>
Date: Fri, 23 May 2014 22:14:42 +0900
From: Akira Hayakawa <ruby.wktk@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: dm-devel@redhat.com
CC: linux-kernel@vger.kernel.org, masami.hiramatsu@gmail.com,
        devel@etsukata.com
Subject: Re: dm-writeboost: Progress Report
References: <537775B0.2060907@gmail.com>
In-Reply-To: <537775B0.2060907@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guys,

This progress report includes very important benchmarking results, which shows
i) Write will always improve - It boosts writes (396% in the best case) even with really small cache (say, 64MB) because of the sophisticated writeback optimization.
ii) Read won't be bad - It doesn't so much deteriorate the read (less than 1% for SSD+HDD case) because of the insignificant overhead.
iii) Good in application workloads - 22% improvement with read-intensive workload and 234-299% improvement with fileserver workload (using dbench)

Yeah, merging Writeboost into the mainline is my goal now and I really need your feedbacks.
For more details, please read the previous post.

Cheers,
- Akira
