Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933004Ab3CHG2d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 01:28:33 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:52293 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180Ab3CHG2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 01:28:32 -0500
Date: Thu, 7 Mar 2013 22:28:27 -0800
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/14] x86, mm, numa: set memblock nid later
Message-ID: <20130308062827.GJ14556@mtj.dyndns.org>
References: <1362718720-27048-1-git-send-email-yinghai@kernel.org>
 <1362718720-27048-10-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362718720-27048-10-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 08:58:35PM -0800, Yinghai Lu wrote:
> Only set memblock nid one time.

Would be awesome if the description explains why we're doing this and
why we're allowed to do this now.

> Also rename numa_register_memblks to numa_check_memblks()
> after move set memblock nid out.

Ah... so, it's getting renamed here.

-- 
tejun
