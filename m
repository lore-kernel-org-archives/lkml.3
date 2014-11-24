Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbaKXKpD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 05:45:03 -0500
Received: from mail.ispras.ru ([83.149.199.45]:35860 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbaKXKpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 05:45:01 -0500
Message-ID: <54730C2A.3020108@ispras.ru>
Date: Mon, 24 Nov 2014 13:44:58 +0300
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Wei Liu <wei.liu2@citrix.com>
CC: Ian Campbell <ian.campbell@citrix.com>, xen-devel@lists.xenproject.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: Re: [PATCH] xen-netback: do not report success if xenvif_alloc()
 fails
References: <1416610588-19816-1-git-send-email-khoroshilov@ispras.ru> <20141124100053.GC30053@zion.uk.xensource.com>
In-Reply-To: <20141124100053.GC30053@zion.uk.xensource.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.11.2014 13:00, Wei Liu wrote:
> On Sat, Nov 22, 2014 at 01:56:28AM +0300, Alexey Khoroshilov wrote:
>> If xenvif_alloc() failes, netback_probe() reports success as well as
>> "online" uevent is emitted. It does not make any sense, but it just
> Sorry, I don't follow. KOBJ_ONLINE event is not emitted in the event of
> xenvif_alloc fails, is it?
Yes, you are right.
>
>> misleads users.
>>
>> The patch implements propagation of error code if xenvif creation fails.
>>
> This patch not only implements propagation of error code when xenvif
> creation fails, but also when xenbus_scanf fails. You can simply write
> "This patch implements propagation of error code for
> backend_create_xenvif".
>
> The rest of this patch looks good to me. Can you rewrite commit message
> and resubmit, thanks.
Ok.

--
Thank you,
Alexey
