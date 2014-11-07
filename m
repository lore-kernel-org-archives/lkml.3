Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbaKGTDN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 14:03:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42787 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834AbaKGTDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 14:03:12 -0500
Date: Fri, 7 Nov 2014 11:03:11 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Al Viro <viro@ZenIV.linux.org.uk>,
        Petr Mladek <pmladek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] debugfs: Fix misuse of seq_printf return value
Message-ID: <20141107190311.GA32624@kroah.com>
References: <20140929124246.3e39dac8@gandalf.local.home>
 <cover.1412031505.git.joe@perches.com>
 <2634b19eb1c04a9d31148c1fe6f1f3819be95349.1412031505.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2634b19eb1c04a9d31148c1fe6f1f3819be95349.1412031505.git.joe@perches.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 04:08:26PM -0700, Joe Perches wrote:
> Adding repeated -1 to the return is not correct.
> 
> Use seq_is_full to test for unnecessary seq_printf uses
> and always return 0.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
