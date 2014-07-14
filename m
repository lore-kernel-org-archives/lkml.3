Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375AbaGNIwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 04:52:18 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:38299 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbaGNIwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 04:52:11 -0400
Date: Mon, 14 Jul 2014 11:51:42 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Eli Billauer <eli.billauer@gmail.com>
Cc: Jeremiah Mahler <jmmahler@gmail.com>, devel@driverdev.osuosl.org,
        Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH] xillybus: place 'else' on same line as '}'
Message-ID: <20140714085142.GK25880@mwanda>
References: <1405307220-15946-1-git-send-email-jmmahler@gmail.com>
 <53C37B67.7000203@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C37B67.7000203@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 09:40:39AM +0300, Eli Billauer wrote:
> Hi,
> 
> Thanks for this.
> 
> And since I looked at the part in Codingstyle that deals with
> if-else, I found another few mistakes regarding braces around a
> single statement. The rules say, it turns out, that if one of the
> clauses in an if-else is longer than one statement, both clauses
> should be wrapped with braces. This rule is broken in lines 162, 536
> and 613 of the same file.
> 
> To avoid possible conflicts, I'll wait for this patch to be applied,
> and submit my corrections after that.

In theory there shouldn't be any need to wait because the rules about
which patches go in first are very clear and predictable.  First come
first serve.  Unless a patch is rejected.  And they are only rejected if
they violate some rule, but normally ok patches go in.

This patch is almost totally ok except it doesn't have "staging" in the
subject.  I'm not sure if that's enough to reject it...  Probably it's
ok and you should assume it will be merged.

The other reason that you don't need to wait is that this patch won't
conflict with the other patch you are proposing.

regards,
dan carpenter

