Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932750AbaGEU2g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 16:28:36 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:34916 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400AbaGEU2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 16:28:33 -0400
Date: Sat, 5 Jul 2014 23:28:21 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andrey Utkin <andrey.krieger.utkin@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        acme@ghostprotocols.net
Subject: Re: [PATCH] appletalk: Set skb with destructor
Message-ID: <20140705202821.GA25880@mwanda>
References: <1404534494-6253-1-git-send-email-andrey.krieger.utkin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404534494-6253-1-git-send-email-andrey.krieger.utkin@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 05, 2014 at 07:28:14AM +0300, Andrey Utkin wrote:
> See https://bugzilla.kernel.org/show_bug.cgi?id=79441
> ---8<---
> Made changes similar to 0ae89beb283a0db5980d1d4781c7d7be2f2810d6
> 

Thanks for fixing this bug but the patch description is just a URL and a
git hash.  Say something like:

The sock ref counting is off so there is a kernel panic when you run
`atalkd`.  See https://bugzilla.kernel.org/show_bug.cgi?id=79441
This fix is similar to 0ae89beb283a ('can: add destructor for self
generated skbs')

--------------------------

Putting a little information directly in the changelog that it is about
refcounting and panics is a useful thing.

Also you need to send this to netdev@vger.kernel.org and CC
"David S. Miller" <davem@davemloft.net>.  Otherwise the patch looks good
to my non-expert eye.  Please resend to with the updated changelog and
CC list.

regards,
dan carpenter

