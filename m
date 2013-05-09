Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465Ab3EILgI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 07:36:08 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:52401
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754373Ab3EILgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 07:36:07 -0400
Message-ID: <1368099347.3453.1.camel@clam>
Subject: Re: [PATCH 20/21] powerpc/ps3: remove inline marking of
 EXPORT_SYMBOL functions
From: Geoff Levand <geoff@infradead.org>
To: Denis Efremov <yefremov.denis@gmail.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org, ldv-project@linuxtesting.org
Date: Thu, 09 May 2013 19:35:47 +0800
In-Reply-To: <1368095819-11011-9-git-send-email-yefremov.denis@gmail.com>
References: <1368086241-9357-1-git-send-email-yefremov.denis@gmail.com>
	 <1368095819-11011-9-git-send-email-yefremov.denis@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-05-09 at 14:36 +0400, Denis Efremov wrote:
> EXPORT_SYMBOL and inline directives are contradictory to each other.
> The patch fixes this inconsistency.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>
> ---
>  arch/powerpc/platforms/ps3/spu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Looks good, thanks.

Acked-by: Geoff Levand <geoff@infradead.org>


