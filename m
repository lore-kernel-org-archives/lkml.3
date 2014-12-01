Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230AbaLALjJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 06:39:09 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:20346 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945AbaLALjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 06:39:08 -0500
Date: Mon, 1 Dec 2014 14:38:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Daniel Borkmann <dborkman@redhat.com>
Cc: tytso@mit.edu, zatimend@hotmail.co.uk, linux-kernel@vger.kernel.org,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Kees Cook <keescook@chromium.org>, Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH] random: add and use memzero_explicit() for clearing data
Message-ID: <20141201113815.GD5048@mwanda>
References: <1408996899-4892-1-git-send-email-dborkman@redhat.com>
 <20141201102529.GA9666@mwanda>
 <547C4B59.1000807@redhat.com>
 <20141201112957.GC5048@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141201112957.GC5048@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 02:29:57PM +0300, Dan Carpenter wrote:
> On Mon, Dec 01, 2014 at 12:04:57PM +0100, Daniel Borkmann wrote:
> > Well, BSD has helpers such as bzero_explicit() for such cases to work
> > around this, which memzero_explicit() similarly does; see also [1].
> > 
> >   [1] https://gcc.gnu.org/ml/gcc-help/2014-10/msg00059.html
> 
> We should make memset() a define and call a custom function internally.
>

Or we could specify -fno-builtin-memset like the GCC people suggest.

regards,
dan carpenter

