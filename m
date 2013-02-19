Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934851Ab3BSXB1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 18:01:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59048 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933463Ab3BSXBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 18:01:25 -0500
Date: Tue, 19 Feb 2013 15:01:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Chuansheng Liu <chuansheng.liu@intel.com>, mingo@kernel.org,
        peterz@infradead.org, jbeulich@suse.com, paulmck@linux.vnet.ibm.com,
        mina86@mina86.org, srivatsa.bhat@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, jun.zhang@intel.com
Subject: Re: [PATCH V2] smp: Give WARN()ing when calling
 smp_call_function_many()/single() in serving irq
Message-Id: <20130219150123.07024b5b.akpm@linux-foundation.org>
In-Reply-To: <20130218013852.GA11231@localhost>
References: <1360163901.24670.13.camel@cliu38-desktop-build>
	<1361023075.11130.12.camel@cliu38-desktop-build>
	<1361023812.11130.15.camel@cliu38-desktop-build>
	<20130218013852.GA11231@localhost>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Feb 2013 09:38:52 +0800
Fengguang Wu <fengguang.wu@intel.com> wrote:

> Chuansheng,
> 
> It works fine on tip/next. Thanks for the fix!
> 
> Tested-by: Fengguang Wu <fengguang.wu@intel.com>

How did you test this?  What did you do?

afacit the patch adds additional warnings, so you must have had some
buggy code and with the patch, runtime warnings are generated which
inform you of that bug?

