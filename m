Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab3AWLbd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 06:31:33 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:55234 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755159Ab3AWLbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 06:31:31 -0500
MIME-Version: 1.0
In-Reply-To: <20130123103108.GA4584@mwanda>
References: <1358541648-29922-1-git-send-email-mark.einon@gmail.com>
 <1358935859-29525-1-git-send-email-mark.einon@gmail.com> <20130123103108.GA4584@mwanda>
From: Mark Einon <mark.einon@gmail.com>
Date: Wed, 23 Jan 2013 11:31:16 +0000
Message-ID: <CANK3SE2qxP5dkYrdpYnWBGqTT5b7HrW_gXS++e73Xr++h6Mokg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 linux-next] et131x: Promote staging et131x driver
 to drivers/net
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: davem@davemloft.net, gregkh@linuxfoundation.org, sfr@canb.auug.org.au,
        devel@driverdev.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 January 2013 10:31, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Wed, Jan 23, 2013 at 10:10:58AM +0000, Mark Einon wrote:
>> diff --git a/drivers/net/ethernet/agere/Kconfig b/drivers/net/ethernet/agere/Kconfig
>> new file mode 100644
>> index 0000000..6854966
>> --- /dev/null
>> +++ b/drivers/net/ethernet/agere/Kconfig
>> @@ -0,0 +1,32 @@
>> +#
>> +# Agere device configuration
>> +#
>> +
>> +config NET_VENDOR_AGERE
>> +       bool "Agere devices"
>> +       default y
>> +       depends on PCI
>> +       ---help---
>> +         If you have a network (Ethernet) card belonging to this class, say Y
>> +         and read the Ethernet-HOWTO, available from
>> +         <http://www.tldp.org/docs.html#howto>.
>> +
>> +         Note that the answer to this question doesn't directly affect the
>> +         kernel: saying N will just cause the configurator to skip all
>> +         the questions about Atheros devices. If you say Y, you will be asked
>                                 ^^^^^^^
> Agere?

Well spotted, thanks. I'll fix it asap.

>
>> +         for your specific card in the following questions.
>> +
>
> I think you should just leave this block out entirely.  It doesn't
> save time for anyone.

It looks to be standard boilerplate for all the net/ethernet drivers
having their own directory. I'm going to leave it in for now.
If that's an issue that needs a change, it would also affect the other
drivers and I think should be tackled as a separate thing.

Cheers,

Mark
