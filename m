Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099AbaHVVNO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 17:13:14 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:33326 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbaHVVNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 17:13:10 -0400
Message-ID: <1408741988.24496.16.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH] drivers: target: target_core_ua_h: Add #define of
 include guard
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 22 Aug 2014 14:13:08 -0700
In-Reply-To: <1408712071-14474-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1408712071-14474-1-git-send-email-linux@rasmusvillemoes.dk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rasmus,

On Fri, 2014-08-22 at 14:54 +0200, Rasmus Villemoes wrote:
> Clearly the file was meant to contain an include guard, but it was
> missing the #define part.
> 
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> ---
>  drivers/target/target_core_ua.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/target/target_core_ua.h b/drivers/target/target_core_ua.h
> index be912b3..a6b56b3 100644
> --- a/drivers/target/target_core_ua.h
> +++ b/drivers/target/target_core_ua.h
> @@ -1,4 +1,5 @@
>  #ifndef TARGET_CORE_UA_H
> +#define TARGET_CORE_UA_H
>  
>  /*
>   * From spc4r17, Table D.1: ASC and ASCQ Assignement

Applied to target-pending.git.

Thanks!

--nab


