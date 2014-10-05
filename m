Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739AbaJEN1P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 09:27:15 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:47694 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbaJEN1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 09:27:14 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Grant Likely <grant.likely@linaro.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@linux.intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] lib: string.c:  A speed optimized for strncpy  
Date: Sun,  5 Oct 2014 15:29:15 +0200
Message-Id: <1412515757-19689-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This variant is in my tests about 7-10% faster, and I also think
it is perhaps even clearer code than before.

I assume that more will do the testing, I do not know if we should do tests
on different types of hardware as well, my test was on a new Intel I7.

Rickard Strandqvist (1):
  lib: string.c:  A speed optimized for strncpy

 lib/string.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

-- 
1.7.10.4

