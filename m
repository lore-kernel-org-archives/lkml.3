Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542AbaLZT5B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 14:57:01 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:34227 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbaLZT5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 14:57:00 -0500
Date: Fri, 26 Dec 2014 19:56:50 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Alex Gartrell <agartrell@fb.com>
Cc: davem@davemloft.net, herbert@gondor.apana.org.au, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH net-next 1/2] socket: Allow external sockets to use
 socket syscalls
Message-ID: <20141226195650.GF22149@ZenIV.linux.org.uk>
References: <1419576624-8999-1-git-send-email-agartrell@fb.com>
 <1419576624-8999-2-git-send-email-agartrell@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419576624-8999-2-git-send-email-agartrell@fb.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 25, 2014 at 10:50:23PM -0800, Alex Gartrell wrote:
> Currently the "is-socket" test for a file compares the ops table pointer,
> which is static and local to the socket.c.  Instead, this adds a flag for
> private_data_is_socket.  This is an exceptionally long commit message for a
> two-line patch.

NAK.  Don't crap into struct file, please.
