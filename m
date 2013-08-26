Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567Ab3HZVZH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 17:25:07 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:42097 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751973Ab3HZVZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 17:25:05 -0400
Message-ID: <1377552303.1877.23.camel@joe-AO722>
Subject: Re: [PATCH RESEND V3 net-next 2/3] net: huawei_cdc_ncm: Introduce
 the huawei_cdc_ncm driver
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: mrkiko.rs@gmail.com, gregkh@linuxfoundation.org, oliver@neukum.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Date: Mon, 26 Aug 2013 14:25:03 -0700
In-Reply-To: <20130826.170922.2228024390320689580.davem@davemloft.net>
References: <1377549913.1877.12.camel@joe-AO722>
	 <20130826.165831.112649899191508957.davem@davemloft.net>
	 <1377551155.1877.18.camel@joe-AO722>
	 <20130826.170922.2228024390320689580.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-08-26 at 17:09 -0400, David Miller wrote:
> From: Joe Perches <joe@perches.com>
[]
> Don't try to over-simplify things and act as if they are black
> and white when they aren't.

It wasn't me simplifying.

I commented on your request to:

"order local function variable declarations by line
 length, longest to shortest."

as it seemed a bit rigid.

And perhaps you didn't read the rest of my email.

>> As a general rule, it's I suppose OK, but as
>> a hardened rule, it's like most all hard rules.
>> It's made to be broken.



