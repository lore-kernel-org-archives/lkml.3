Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101Ab3C1Lfb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 07:35:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36641 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754922Ab3C1Lf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 07:35:28 -0400
Date: Thu, 28 Mar 2013 11:35:20 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Mugunthan V N <mugunthanvnm@ti.com>
Cc: joe@perches.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 1/1] checkpatch: adding Suggested-by as standard
 signature
Message-ID: <20130328113520.GF3677@localhost>
References: <1364455702-13900-1-git-send-email-mugunthanvnm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364455702-13900-1-git-send-email-mugunthanvnm@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28, 2013 at 12:58:22PM +0530, Mugunthan V N wrote:

> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -281,6 +281,7 @@ our $signature_tags = qr{(?xi:
>  	Tested-by:|
>  	Reviewed-by:|
>  	Reported-by:|
> +	Suggested-by:|
>  	To:|
>  	Cc:
>  )};

Looks reasonable to me.

-apw
