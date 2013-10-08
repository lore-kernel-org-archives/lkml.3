Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298Ab3JHJDw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 05:03:52 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:46627 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754698Ab3JHJDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 05:03:51 -0400
Date: Tue, 8 Oct 2013 13:03:49 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Pavel Emelyanov <xemul@parallels.com>, linux-mm@kvack.org,
        Wu Fengguang <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2 v2] smaps: show VM_SOFTDIRTY flag in VmFlags line
Message-ID: <20131008090349.GB31343@moon>
References: <1380913335-17466-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <5252B56C.8030903@parallels.com>
 <1381155304-2ro6e10t-mutt-n-horiguchi@ah.jp.nec.com>
 <20131007175125.7bb300853d37b6a64eba248d@linux-foundation.org>
 <20131008085901.GN6036@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131008085901.GN6036@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 12:59:01PM +0400, Cyrill Gorcunov wrote:
> On Mon, Oct 07, 2013 at 05:51:25PM -0700, Andrew Morton wrote:
> > 
> > Documentation/filesystems/proc.txt needs updating, please.
> 
> I'll do this today.

Ouch, it seems I've missed the reply and Naoya already has it done.
