Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751Ab3A0NJM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 08:09:12 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:63080 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756683Ab3A0NJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 08:09:10 -0500
Date: Sun, 27 Jan 2013 14:09:05 +0100
From: Ingo Molnar <mingo@kernel.org>
To: ling.ma.program@gmail.com
Cc: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org, Ma Ling <ling.ml@alipay.com>
Subject: Re: [PATCH V2] [x86]: Compiler Option Os is better on latest x86
Message-ID: <20130127130905.GD3933@gmail.com>
References: <1359203052-5159-1-git-send-email-ling.ma@alipay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359203052-5159-1-git-send-email-ling.ma@alipay.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* ling.ma.program@gmail.com <ling.ma.program@gmail.com> wrote:

> In this version we also append CONFIG_CC_OPTIMIZE_FOR_SIZE for i386.

Were those measurements done on i386 as well? I'd be content 
with keeping the current minimal - and mostly documentary - 
patch that only does this on 64-bit. I just wanted to record the 
current benchmark numbers mostly.

Also see the discussion with Linus - this is by no far an 
unconditionally good option and we'll probably have to wait for 
more GCC action (-Ok or so) before being able to enable size 
optimizations everywhere without unacceptable trade-offs.

Thanks,

	Ingo
