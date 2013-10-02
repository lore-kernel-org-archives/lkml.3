Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203Ab3JBHz4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 03:55:56 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:33423 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895Ab3JBHzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 03:55:55 -0400
Date: Wed, 2 Oct 2013 10:55:39 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mathieu =?iso-8859-1?Q?Rh=E9aume?= <mathieu@codingrhemes.com>
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        serban.constantinescu@arm.com, linux-kernel@vger.kernel.org,
        arve@android.com, mirsal@mirsal.fr
Subject: Re: [PATCH] Staging : android: binder.c: Prefer seq_puts to
 seq_printf
Message-ID: <20131002075539.GV6192@mwanda>
References: <1380679056-10175-1-git-send-email-mathieu@codingrhemes.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1380679056-10175-1-git-send-email-mathieu@codingrhemes.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 01, 2013 at 09:57:36PM -0400, Mathieu Rhéaume wrote:
> This patch changes seq_printf for seq_puts in binder.c.
> It fixes the warnings emitted by checkpatch.pl.

Which warnings?  Seems like a false positive somehow because seq_puts()
is totally wrong here.  This doesn't compile.

regards,
dan carpenter

