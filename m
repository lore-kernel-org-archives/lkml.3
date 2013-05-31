Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088Ab3EaG3I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 02:29:08 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:35119 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901Ab3EaG3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 02:29:04 -0400
Message-ID: <51A8432A.4000602@gmail.com>
Date: Fri, 31 May 2013 08:28:58 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: buytenh@wantstofly.org, jason@lakedaemon.net, andrew@lunn.ch,
        benh@kernel.crashing.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 00/13] net: mv643xx_eth DT support and fixes
References: <1369154510-4927-1-git-send-email-sebastian.hesselbarth@gmail.com> <1369855975-21489-1-git-send-email-sebastian.hesselbarth@gmail.com> <20130530.175549.407800685811475192.davem@davemloft.net>
In-Reply-To: <20130530.175549.407800685811475192.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2013 02:55 AM, David Miller wrote:
> From: Sebastian Hesselbarth<sebastian.hesselbarth@gmail.com>
> Date: Wed, 29 May 2013 21:32:42 +0200
>
>> For the patches above I suggest to take Patches 1-6 through David
>> Miller's branch, and Patches 7-12 through Jason Cooper's when the
>> former have appeared on mainline linux. The patch set has been based
>> on v3.10-rc3.
>
> Patches 1-6 applied to net-next, and patch #1 queued up for -stable.

David,

thanks for pulling these in. I finally found how to check if a patch
already went into -stable. As Jason already said, the mdio patch that
#1 fixes did not yet went into -stable. Can you unqueue it? Sorry for
the confusion.

Sebastian

