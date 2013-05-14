Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227Ab3ENLtg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 07:49:36 -0400
Received: from mail-da0-f53.google.com ([209.85.210.53]:48368 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757074Ab3ENLtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 07:49:35 -0400
Message-ID: <519224C7.3010908@gmail.com>
Date: Tue, 14 May 2013 19:49:27 +0800
From: majianpeng <majianpeng@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: linux-mm <linux-mm@kvack.org>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] mm/kmemleak.c: Fix some trivial problems.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jianpeng Ma (3):
  mm/kmemleak.c: Use %u to print ->checksum.
  mm/kmemleak.c: Use list_for_each_entry_safe to reconstruct function   
     scan_gray_list.
  mm/kmemleak.c: Merge the consecutive scan-areas.

 mm/kmemleak.c | 36 +++++++++++++++++++++---------------
 1 file changed, 21 insertions(+), 15 deletions(-)

-- 
1.8.3.rc1.44.gb387c77

