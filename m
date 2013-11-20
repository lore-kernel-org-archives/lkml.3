Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718Ab3KTKVw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 05:21:52 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:27119 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752020Ab3KTKVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 05:21:51 -0500
Message-ID: <528C8D3D.6050600@c-s.fr>
Date: Wed, 20 Nov 2013 11:21:49 +0100
From: leroy christophe <christophe.leroy@c-s.fr>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
CC: LinuxPPC-dev <linuxppc-dev@lists.ozlabs.org>, linux-kernel@vger.kernel.org,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>
Subject: BUG: Patch "Convert some mftb/mftbu into mfspr" breaks MPC885
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scott,

The patch "Convert some mftb/mftbu into mfspr" 
(beb2dc0a7a84be003ce54e98b95d65cc66e6e536) breaks startup on MPC885.

The CPU traps (SoftwareEmulation trap) at sched_clock() when trying to 
read TBU with mfspr.

Reverting the patch solves the issue.

What's the prefered way to fix this ?

Christophe
