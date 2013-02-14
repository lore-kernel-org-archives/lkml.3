Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934711Ab3BNQHp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 11:07:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:60468 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757931Ab3BNQHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 11:07:44 -0500
Message-ID: <511D0BCC.9070208@canonical.com>
Date: Thu, 14 Feb 2013 11:07:40 -0500
From: Joseph Salisbury <joseph.salisbury@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130105 Thunderbird/17.0.2
MIME-Version: 1.0
To: mc74hc00@gmail.com
CC: wim@iguana.be, linux-watchdog@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Kernel Team <kernel-team@lists.ubuntu.com>
Subject: [v3.8 Regression] watchdog: sp5100_tco: Add SB8x0 chipset support
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Takahisa,

A bug was opened against the Ubuntu kernel[0].  It was found that 
reverting the following commit resolved this bug:

commit 740fbddf5c3f9ad8b23c5d917ba1cc7e376a5104
Author: Takahisa Tanaka <mc74hc00@gmail.com>
Date:   Sun Dec 2 14:33:18 2012 +0900

     watchdog: sp5100_tco: Add SB8x0 chipset support


The regression was introduced as of v3.8-rc1.

I see that you are the author of this patch, so I wanted to run this by 
you.  I was thinking of requesting a revert for v3.8, but I wanted to 
get your feedback first.


Thanks,

Joe

[0] http://pad.lv/1116835
