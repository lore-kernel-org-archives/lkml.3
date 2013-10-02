Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab3JBIAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 04:00:19 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:46344 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab3JBIAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 04:00:16 -0400
Date: Wed, 2 Oct 2013 10:59:48 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mathieu =?iso-8859-1?Q?Rh=E9aume?= <mathieu@codingrhemes.com>
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        serban.constantinescu@arm.com, linux-kernel@vger.kernel.org,
        arve@android.com, mirsal@mirsal.fr, joe@perches.com
Subject: Re: [PATCH v3] Staging : android: binder.c: Prefer seq_puts to
 seq_printf
Message-ID: <20131002075948.GW6192@mwanda>
References: <1380690159-17623-1-git-send-email-mathieu@codingrhemes.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1380690159-17623-1-git-send-email-mathieu@codingrhemes.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 01:02:39AM -0400, Mathieu Rhéaume wrote:
> Changes since v2:
>  * Fixed the indent in the method calls that had too many tab.
> 
> >8------------------------------------------------------8<
> 
> This patch changes seq_printf for seq_puts in binder.c.
> It fixes the warnings emitted by checkpatch.pl.

Checkpatch.pl is wrong here and this doesn't compile.

regards,
dan carpenter

