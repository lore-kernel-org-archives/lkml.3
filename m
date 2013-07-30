Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751215Ab3G3M3m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 08:29:42 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:41984 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750748Ab3G3M3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 08:29:41 -0400
Message-ID: <1375187380.2075.111.camel@joe-AO722>
Subject: Re: [PATCH trivial] include/linux/coda.h: remove useless '#else'
From: Joe Perches <joe@perches.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: "'Jiri Kosina'" <trivial@kernel.org>, jaharkes@cs.cmu.edu, coda@cs.cmu.edu,
        codalist@TELEMANN.coda.cs.cmu.edu,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 30 Jul 2013 05:29:40 -0700
In-Reply-To: <51F76B7D.2090602@asianux.com>
References: <51F76B7D.2090602@asianux.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-30 at 15:30 +0800, Chen Gang wrote:
> '#else' is useless, need remove.
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  include/linux/coda.h |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/coda.h b/include/linux/coda.h
> index cff544f..d30209b 100644
> --- a/include/linux/coda.h
> +++ b/include/linux/coda.h
> @@ -60,7 +60,6 @@ Mellon the rights to redistribute these changes without encumbrance.
>  
>  #if defined(__linux__)
>  typedef unsigned long long u_quad_t;
> -#else
>  #endif
>  #include <uapi/linux/coda.h>
>  #endif 

Why have the #if at all?

