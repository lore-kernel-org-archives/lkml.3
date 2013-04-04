Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764146Ab3DDRsi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 13:48:38 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:47649 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764114Ab3DDRsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 13:48:37 -0400
Date: Thu, 4 Apr 2013 10:48:30 -0700
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org, Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: [PATCH v2 02/20] x86, microcode: Use common get_ramdisk_image()
Message-ID: <20130404174830.GR9425@htj.dyndns.org>
References: <1362897887-30808-1-git-send-email-yinghai@kernel.org>
 <1362897887-30808-3-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362897887-30808-3-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 09, 2013 at 10:44:29PM -0800, Yinghai Lu wrote:
> Use common get_ramdisk_image() to get ramdisk start phys address.
> 
> We need this to get correct ramdisk adress for 64bit bzImage that
> initrd can be loaded above 4G by kexec-tools.

Is this a bug fix?  Can it actually happen?

> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Fenghua Yu <fenghua.yu@intel.com>

For 01 and 02

 Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
