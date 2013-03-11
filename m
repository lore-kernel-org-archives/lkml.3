Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab3CKQsX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 12:48:23 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60699 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815Ab3CKQsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 12:48:21 -0400
Date: Mon, 11 Mar 2013 16:47:41 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: gang.chen@asianux.com, mgherzan@gmail.com, nschichan@freebox.fr,
        daniel.borkmann@tik.ee.ethz.ch, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM:net: an issue for k which is u32, never < 0
Message-ID: <20130311164741.GL4977@n2100.arm.linux.org.uk>
References: <513BECDA.3030803@asianux.com> <20130310.171238.330349067962026661.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130310.171238.330349067962026661.davem@davemloft.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 10, 2013 at 05:12:38PM -0400, David Miller wrote:
> From: Chen Gang <gang.chen@asianux.com>
> Date: Sun, 10 Mar 2013 10:15:54 +0800
> 
> > 
> >   k is u32 which never < 0, need type cast, or cause issue.
> > 
> > Signed-off-by: Chen Gang <gang.chen@asianux.com>
> 
> Who will apply this, ARM folks or me?

I'm happy if you wish to take the patch:

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

Thanks.
