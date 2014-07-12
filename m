Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938AbaGLMQ3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 08:16:29 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:19456 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893AbaGLMQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 08:16:27 -0400
Date: Sat, 12 Jul 2014 15:16:13 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, julia.lawall@lip6.fr,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] drivers: tty: Merge alloc_tty_struct and
 initialize_tty_struct
Message-ID: <20140712121613.GY23001@mwanda>
References: <1405018882-19073-1-git-send-email-linux@rasmusvillemoes.dk>
 <1405162551-23308-1-git-send-email-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405162551-23308-1-git-send-email-linux@rasmusvillemoes.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 12, 2014 at 12:55:51PM +0200, Rasmus Villemoes wrote:
> The two functions alloc_tty_struct and initialize_tty_struct are
> always called together. Merge them into alloc_tty_struct, updating its
> prototype and the only two callers of these functions.
> 
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> ---
> I hope this is sufficient. Thanks, Dan and Julia!

Generally Greg's trees can't be rebased.  I think you need to send a fix
patch.

regards,
dan carpenter

