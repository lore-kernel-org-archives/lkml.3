Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab3JZTAK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 15:00:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33881 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442Ab3JZTAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 15:00:07 -0400
Date: Sat, 26 Oct 2013 20:01:51 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: Jason Baron <jbaron@akamai.com>, Andrew Morton <akpm@linux-foundation.org>,
        Krzysztof Mazur <krzysiek@podlesie.net>, Felipe Balbi <balbi@ti.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] printk: pr_debug_ratelimited: check state first to
 reduce "callbacks suppressed" messages
Message-ID: <20131026190151.GA26389@kroah.com>
References: <20131026132955.GA9251@shrek.podlesie.net>
 <20131026173730.GA18320@kroah.com>
 <1382813522.3238.4.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382813522.3238.4.camel@joe-AO722>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 26, 2013 at 11:52:02AM -0700, Joe Perches wrote:
> pr_debug_ratelimited should be coded similar to dev_dbg_ratelimited
> to reduce the "callbacks suppressed" messages.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Looks good, I'll queue both of these up soon.

greg k-h
