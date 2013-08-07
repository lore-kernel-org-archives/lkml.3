Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932913Ab3HGUWJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 16:22:09 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:44839 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932727Ab3HGUWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 16:22:06 -0400
Date: Wed, 7 Aug 2013 16:22:01 -0400
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <kmo@daterainc.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH 03/10] idr: Rewrite ida
Message-ID: <20130807202201.GA28039@mtj.dyndns.org>
References: <1375896905-6074-1-git-send-email-kmo@daterainc.com>
 <1375896905-6074-4-git-send-email-kmo@daterainc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375896905-6074-4-git-send-email-kmo@daterainc.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Kent.

On Wed, Aug 07, 2013 at 10:34:58AM -0700, Kent Overstreet wrote:
> + * So for 1 mb of memory (and allocating more than that should be fine with
> + * CONFIG_COMPACTION) you get slightly under 8 million IDs.

Nothing seems to explain the section thing.  This is broken up now,
right?  Where's the documentation?

Thanks.

-- 
tejun
