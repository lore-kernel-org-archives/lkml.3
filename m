Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbaIPIIX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 04:08:23 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:51678 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274AbaIPIIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 04:08:21 -0400
Date: Tue, 16 Sep 2014 10:08:14 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] locking: Add WARN_ON_ONCE lock assertion
Message-ID: <20140916080814.GA24921@gmail.com>
References: <1410373899-4113-1-git-send-email-peter@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410373899-4113-1-git-send-email-peter@hurleysoftware.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Hurley <peter@hurleysoftware.com> wrote:

> An interface may need to assert a lock invariant and not flood the
> system logs; add a lockdep helper macro equivalent to
> lockdep_assert_held() which only WARNs once.
> 
> cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
