Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655AbaHMRRi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 13:17:38 -0400
Received: from senator.holtmann.net ([87.106.208.187]:34704 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852AbaHMRRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 13:17:36 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH] bluetooth/dtl1_cs: Remove typedefs nsh_t and dtl1_info_t
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20140813092227.GA3221@himangi-Dell>
Date: Wed, 13 Aug 2014 10:18:07 -0700
Cc: "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Content-Transfer-Encoding: 7bit
Message-Id: <F6AE85DE-D6AB-45E1-B6EF-FE5BA239267B@holtmann.org>
References: <20140813092227.GA3221@himangi-Dell>
To: Himangi Saraogi <himangi774@gmail.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Himangi,

> The Linux kernel coding style guidelines suggest not using typedefs
> for structure types. This patch gets rid of the typedefs for nsh_t and
> dtl1_info_t. Also, the name of the struct is changed to drop the _t,
> to make the name look less typedef-like.
> 
> The following Coccinelle semantic patch detects the case for dtl1_info_t
> and a similar patch finds the nsh_t case:
> 
> @tn@
> identifier i;
> type td;
> @@
> 
> -typedef
> struct i { ... }
> -td
> ;
> 
> @@
> type tn.td;
> identifier tn.i;
> @@
> 
> -td
> + struct i
> 
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>
> ---
> drivers/bluetooth/dtl1_cs.c | 36 ++++++++++++++++++------------------
> 1 file changed, 18 insertions(+), 18 deletions(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

