Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090AbaEREDa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 00:03:30 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:62254 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbaERED3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 00:03:29 -0400
MIME-Version: 1.0
Date: Sun, 18 May 2014 00:03:28 -0400
Message-ID: <CALN0BAu_ibgpVykHL-byKm_4X1Afr1R1LRC5ocYVzcqA_k=_9Q@mail.gmail.com>
Subject: remap_file_pages() use
From: Kenny Simpson <theonetruekenny@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I saw that remap_file_pages() was possibly going away to be replaced
by some emulation. I've used this call in several projects over the
years mostly as a way of mapping multiple virtual memory pages to
alias the same private or shared memory region (to do things like
circular buffers). mmap()
in the case of anonymous memory doesn't work as well since there is
not a file descriptor to reference.

Would this sort of thing be supported in the emulation, or should I be
planning on reimplementing/rewriting some things?

thanks,
-Kenny
