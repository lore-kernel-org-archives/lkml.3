Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932936AbaJUORl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 10:17:41 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:21234 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932711AbaJUORk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 10:17:40 -0400
Date: Tue, 21 Oct 2014 17:17:24 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Matej =?utf-8?Q?Mu=C5=BEila?= <mmuzila@redhat.com>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] tools: hv: fcopy_daemon: Check buffer limits
Message-ID: <20141021141724.GM23154@mwanda>
References: <5446482C.1000003@redhat.com>
 <20141021131357.3677c4a5@alan.etchedpixels.co.uk>
 <544658CE.8050704@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <544658CE.8050704@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 02:59:58PM +0200, Matej Mužila wrote:
> > sizeof(__u8) is by definition 1 so it's perhaps surplus ?
> Now the size is now determined from the structure definition in
> include/uapi/linux/hyperv.h
> 
> > - C style comments for coding style
> Fixed
> 
> > Also your patch block is devoid of a few thins like the file name...
> I'm sorry, the (missing) filename mistake occured in copy-paste process.
> 

Copy and paste is very error prone...

> 
> Here is the patch as it (I hope) should look like:

This patch looks good, but please resend it as a proper v2 patch.

https://www.google.com/search?q=how+to+send+a+v2+patch

> ---
> From: Matej Mužila <mmuzila@redhat.com>
> 
> Check if cpmsg->size is in limits of DATA_FRAGMENT
> 
> Signed-off-by: Matej Mužila <mmuzila@redhat.com>
> ---
> If corrupted data are read from /dev/vmbus/hv_fcopy, pwrite can
> read from memory outside of the buffer (defined at line 138).
> Added check. 

Put this information in the patch description and not beyond the cut
off.  That information is useful.

The cut off is meant for meta comentary to say what changed between v1
and v2 etc, which is nice to have but we don't want to preserve it.

regards,
dan carpenter


