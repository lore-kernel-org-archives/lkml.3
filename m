Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212Ab3JWWDE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 18:03:04 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:23931 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830Ab3JWWDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 18:03:03 -0400
Date: Thu, 24 Oct 2013 01:02:45 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chuong Ngo <cngo.github@gmail.com>
Cc: gregkh@linuxfoundation.org, klmckinney1@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: staging: bcm:  Removed a developer debug
 statement.
Message-ID: <20131023220245.GF9378@mwanda>
References: <1382555480-26605-1-git-send-email-cngo.github@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382555480-26605-1-git-send-email-cngo.github@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 03:11:20PM -0400, Chuong Ngo wrote:
> Removed a developer debug statement per the TODO list.  Additionally, removed braces for the if-statement to match coding style.

Line wrap the changelog at 72 characters.  You don't really need to
mention the removed braces because that's too obvious to bother
commenting on.

My guess is that Greg will probably be willing to apply this as is so
don't worry about resending unless he requests it.  (He normally seems
to let newbies get by with one line wrapping warning before he starts
making you redo it).

regards,
dan carpenter

