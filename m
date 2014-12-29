Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185AbaL2RlV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 12:41:21 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:45711 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbaL2RlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 12:41:20 -0500
Date: Mon, 29 Dec 2014 09:41:16 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Jonas Lundqvist <jonas@gannon.se>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: line6: remove spaces before commas.
Message-ID: <20141229174116.GA31402@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Jonas Lundqvist <jonas@gannon.se>, gregkh@linuxfoundation.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <20141229070239.GC3749@sudip-PC>
 <1419867258-3146-1-git-send-email-jonas@gannon.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419867258-3146-1-git-send-email-jonas@gannon.se>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonas,

In your subject line, when you create a new version of a patch, include
the version number.  In this case it would be "[PATCH v2]".

On Mon, Dec 29, 2014 at 04:34:18PM +0100, Jonas Lundqvist wrote:
> Fixed three errors in pcm.h found by checkpatch.pl:
> 
> drivers/staging/line6/pcm.h:148: ERROR: space prohibited before that ','
> (ctx:WxE)
> drivers/staging/line6/pcm.h:155: ERROR: space prohibited before that ','
> (ctx:WxE)
> drivers/staging/line6/pcm.h:162: ERROR: space prohibited before that ','
> (ctx:WxE)
> 
It is better than no description at all. But listing each identical
error is redundant.  I would have just said something to the effect of
"fix three space prohibited errors ...".

> Signed-off-by: Jonas Lundqvist <jonas@gannon.se>
> ---
>  drivers/staging/line6/pcm.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
[...]

-- 
- Jeremiah Mahler
