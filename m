Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441AbaBTAJL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 19:09:11 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:48186 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813AbaBTAJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 19:09:09 -0500
Date: Wed, 19 Feb 2014 19:09:05 -0500
From: Tejun Heo <tj@kernel.org>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: davem@davemloft.net, sergei.shtylyov@cogentembedded.com,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ata: libahci: make ahci_pmp_retry_softreset() as
 static
Message-ID: <20140220000905.GT10134@htj.dyndns.org>
References: <1784085.43ZIZYgGND@daeseok-laptop.cloud.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1784085.43ZIZYgGND@daeseok-laptop.cloud.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 08:34:27AM +0900, Daeseok Youn wrote:
> From 6f865fde2e48ddc09f940ec30ebfc144cf074fd1 Mon Sep 17 00:00:00 2001
> From: Daeseok Youn <daeseok.youn@gmail.com>
> Date: Wed, 19 Feb 2014 10:56:37 +0900
> Subject: [PATCH] ata: libahci: make ahci_pmp_retry_softreset() as static
> 
> sparse says:
> 
> drivers/ata/libahci.c:1390:5: warning:
>  symbol 'ahci_pmp_retry_softreset' was not declared. Should it be static?
> 
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>

Applied to libata/for-3.15.

Thanks.

-- 
tejun
