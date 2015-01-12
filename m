Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbbALMmV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 07:42:21 -0500
Received: from casper.infradead.org ([85.118.1.10]:44707 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbbALMmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 07:42:19 -0500
Date: Mon, 12 Jan 2015 12:42:16 +0000
From: Thomas Graf <tgraf@suug.ch>
To: Ying Xue <ying.xue@windriver.com>
Cc: linux-kernel@vger.kernel.org, lkp@01.org, Netdev <netdev@vger.kernel.org>
Subject: Re: Fwd: [rhashtable] WARNING: CPU: 0 PID: 10 at
 kernel/locking/mutex.c:570 mutex_lock_nested()
Message-ID: <20150112124216.GA26570@casper.infradead.org>
References: <20150110194803.GA9033@wfg-t540p.sh.intel.com>
 <54B3259B.7080601@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54B3259B.7080601@windriver.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <tgraf@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/15 at 09:38am, Ying Xue wrote:
> Hi Thomas,
> 
> I am really unable to see where is wrong leading to below warning
> complaints. Can you please help me check it?

Not sure yet. It's not your patch that introduced the issue though.
It merely exposed the affected code path.

Just wondering, did you test with CONFIG_DEBUG_MUTEXES enabled?
