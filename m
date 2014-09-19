Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757650AbaISRR7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 13:17:59 -0400
Received: from sauhun.de ([89.238.76.85]:52178 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756107AbaISRR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 13:17:57 -0400
Date: Fri, 19 Sep 2014 19:18:18 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Bastian Hecht <hechtb@gmail.com>
Cc: linux-i2c@vger.kernel.org, Linux-SH <linux-sh@vger.kernel.org>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/5] i2c: Don't start transfers when suspended
Message-ID: <20140919171818.GA2874@katana>
References: <1405608520-5644-1-git-send-email-hechtb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405608520-5644-1-git-send-email-hechtb@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 04:48:36PM +0200, Bastian Hecht wrote:
> i2c transfer requests come in very uncontrolled, like from interrupt routines.
> We might be suspended when this happens. To avoid i2c timeouts caused by
> powered down busses we check for suspension.
> 
> Several bus drivers handle this problem on their own. We can clean things up
> by moving the protection mechanism into the core.
> 
> Signed-off-by: Bastian Hecht <hechtb@gmail.com>

Dropping this series due to the comments. I am not sure if it is worth
to add information about the clients being "normally" suspendable or
not. Thanks Bastian for the effort, though.

