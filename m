Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277AbaC0CUW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 22:20:22 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:39932 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751567AbaC0CUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 22:20:20 -0400
Message-ID: <53338ADF.3060803@hurleysoftware.com>
Date: Wed, 26 Mar 2014 22:20:15 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: balbi@ti.com
CC: Greg KH <gregkh@linuxfoundation.org>,
        Marcel Holtmann <marcel@holtmann.org>, linux-serial@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, m-karicheri2@ti.com,
        b32955@freescale.com,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/11] bluetooth: hci_ldisc: fix deadlock condition
References: <1395343807-21618-1-git-send-email-balbi@ti.com> <1395343807-21618-9-git-send-email-balbi@ti.com> <53337513.1010708@hurleysoftware.com> <20140327020909.GA11651@saruman.home>
In-Reply-To: <20140327020909.GA11651@saruman.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2014 10:09 PM, Felipe Balbi wrote:
>> I just noticed this patch wasn't addressed to Marcel;
>> seems like this should go through the bluetooth tree (but not
>> through bluetooth-next because it fixes an oops).
>
> read the archives:
>
> http://marc.info/?l=linux-bluetooth&m=139534449409583&w=2

Sorry. I did actually get Marcel's reply but Thunderbird
didn't parent the reply properly in my inbox and I forgot about it.


>> Marcel,
>>
>> You may want to build on top of this patch split handling;
>> I noticed some of the protocol drivers are calling
>> hci_uart_tx_wakeup() from work functions already (so don't
>> need to schedule another work...)
>
> I don't think that should be part of $subject, though.

I don't understand what you mean here.

Regards,
Peter Hurley

