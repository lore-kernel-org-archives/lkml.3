Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965960Ab3HHRXn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 13:23:43 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:49493 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757910Ab3HHRXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 13:23:42 -0400
Message-ID: <1375982622.2424.147.camel@joe-AO722>
Subject: Re: [PATCH 2/2] Staging: BCM: Removed more whitespace/Errors
From: Joe Perches <joe@perches.com>
To: Paul McQuade <paulmcquad@gmail.com>
Cc: gregkh@linuxfoundation.org, Linux-Devel <devel@driverdev.osuosl.org>,
        Linux-kernel <linux-kernel@vger.kernel.org>
Date: Thu, 08 Aug 2013 10:23:42 -0700
In-Reply-To: <5203CF75.802@gmail.com>
References: <5203CF75.802@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please send your changes with an email client
that does not require attaching patches.

On Thu, 2013-08-08 at 18:03 +0100, Paul McQuade wrote:

> -#define MAXIMUM_USB_TCB      128
> -#define MAXIMUM_USB_RCB         128
> +#define MAXIMUM_USB_TCB                        128
> +#define MAXIMUM_USB_RCB                        128
>  
>  #define MAX_BUFFERS_PER_QUEUE   256
>  
>  #define MAX_DATA_BUFFER_SIZE    2048
 
If you're going to bother to change whitespace
here, please align these like the others.

There are also many style defect like:

+               } else {
+                               BCM_DEBUG_PRINT(Adapter, DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL, "Rx URB has got cancelled. status 

so I stopped looking.

