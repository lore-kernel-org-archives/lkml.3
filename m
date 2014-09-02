Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340AbaIBV6v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 17:58:51 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:42901 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750820AbaIBV6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 17:58:48 -0400
Message-ID: <54063D96.30703@hurleysoftware.com>
Date: Tue, 02 Sep 2014 17:58:46 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Murali Karicheri <m-karicheri2@ti.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH 01/26] Revert "serial: uart: add hw flow control support
 configuration"
References: <1409693975-1028-1-git-send-email-peter@hurleysoftware.com> <1409693975-1028-2-git-send-email-peter@hurleysoftware.com> <54063BA1.2030206@ti.com>
In-Reply-To: <54063BA1.2030206@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2014 05:50 PM, Murali Karicheri wrote:
> Peter,
> 
> On 09/02/2014 05:39 PM, Peter Hurley wrote:
>>  Finally, this patch
>> supposes to fix existing bugs in the serial core for auto CTS-enabled
>> hardware, but does not include the class of hardware for which these
>> bugs exist.
> 
> What is this? What class of hardware are you referring to?

UART_CAP_AFE and UART_CAP_EFR hardware.

> As discussed, I will send an updated patch for this as discussed..

Great.

And since that patch will touch every single line this reverts (and more)
with a different solution, I see no reason not to back this out.

Plus, as you can see, you're holding up progress.

Regards,
Peter Hurley

