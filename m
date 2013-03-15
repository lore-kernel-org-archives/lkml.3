Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab3COQrH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 12:47:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:31821 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920Ab3COQrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 12:47:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,852,1355126400"; 
   d="scan'208";a="215187337"
Date: Fri, 15 Mar 2013 17:46:25 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: New MFD tree for linux-next
Message-ID: <20130315164625.GA29531@zurbaran>
References: <20130314000201.GA4425@zurbaran>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130314000201.GA4425@zurbaran>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Thu, Mar 14, 2013 at 01:02:01AM +0100, Samuel Ortiz wrote:
> Hi Stephen,
> 
> I am moving the MFD development from mfd-2.6.git/for-next to a new mfd-next
> tree:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-next.git
> 
> Could you please point linux-next at it ? Many thanks in advance.
I'm also carrying MFD fixes through the mfd-fixes tree:

git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-fixes.git

Could you please also add it to linux-next ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
