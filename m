Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644AbaITIIw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 04:08:52 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:61584 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbaITIIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 04:08:49 -0400
Date: Sat, 20 Sep 2014 12:08:45 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Peter Feiner <pfeiner@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Pavel Emelyanov <xemul@parallels.com>, Jamie Liu <jamieliu@google.com>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: softdirty: keep bit when zapping file pte
Message-ID: <20140920080845.GX16395@moon>
References: <1411200187-40896-1-git-send-email-pfeiner@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411200187-40896-1-git-send-email-pfeiner@google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 20, 2014 at 01:03:07AM -0700, Peter Feiner wrote:
> Fixes the same bug as b43790eedd31e9535b89bbfa45793919e9504c34 and
> 9aed8614af5a05cdaa32a0b78b0f1a424754a958 where the return value of
> pte_*mksoft_dirty was being ignored.
> 
> To be sure that no other pte/pmd "mk" function return values were
> being ignored, I annotated the functions in
> arch/x86/include/asm/pgtable.h with __must_check and rebuilt.
> 
> Signed-off-by: Peter Feiner <pfeiner@google.com>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>

I might be missing it, thanks a huge Peter!
