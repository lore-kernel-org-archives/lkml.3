Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855Ab3G0Nba (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 09:31:30 -0400
Received: from mxout1.netvision.net.il ([194.90.9.20]:33821 "EHLO
	mxout1.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab3G0Nb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 09:31:26 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII; format=flowed
Message-id: <51F3CB7A.1060409@gmail.com>
Date: Sat, 27 Jul 2013 16:30:34 +0300
From: Eli Billauer <eli.billauer@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12)
 Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the staging tree
References: <20130726160254.83bbe994219d6ee732c64b7d@canb.auug.org.au>
 <20130726210335.GA2788@kroah.com> <51F2E8A4.2010405@gmail.com>
 <20130726215634.GA31820@kroah.com> <51F2FE34.8010601@gmail.com>
 <20130726232855.GA2492@kroah.com>
In-reply-to: <20130726232855.GA2492@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Greg,

I upgraded sparse 0.4.2 -> 0.4.4 and now we see the same error messages.

It will take me a few days to prepare a patch for that.

Thanks for your patience.
     Eli

On 27/07/13 02:28, Greg KH wrote:
> $ make M=drivers/staging/xillybus/ C=1
>    LD      drivers/staging/xillybus//built-in.o
>    CHECK   drivers/staging/xillybus//xillybus_core.c
> drivers/staging/xillybus//xillybus_core.c:76:25: warning: symbol 'xillybus_wq' was not declared. Should it be static?
> drivers/staging/xillybus//xillybus_core.c:175:57: warning: incorrect type in argument 2 (different address spaces)
> drivers/staging/xillybus//xillybus_core.c:175:57:    expected void [noderef]<asn:2>*<noident>
> drivers/staging/xillybus//xillybus_core.c:175:57:    got unsigned int [usertype] *
> drivers/staging/xillybus//xillybus_core.c:309:39: warning: incorrect type in argument 2 (different address spaces)
> drivers/staging/xillybus//xillybus_core.c:309:39:    expected void [noderef]<asn:2>*<noident>
> drivers/staging/xillybus//xillybus_core.c:309:39:    got unsigned int [usertype] *
> drivers/staging/xillybus//xillybus_core.c:606:55: warning: incorrect type in argument 2 (different address spaces)
> drivers/staging/xillybus//xillybus_core.c:606:55:    expected void [noderef]<asn:2>*<noident>
> drivers/staging/xillybus//xillybus_core.c:606:55:    got unsigned int [usertype] *
>
> and goes on for a few screens.
>
> $ sparse --version
> 0.4.4
>
> Try a newer version and see if that fixes things.
>    


