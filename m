Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567AbaIXTbT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 15:31:19 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:57562 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921AbaIXTbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 15:31:16 -0400
Message-ID: <54231BFF.5070901@cogentembedded.com>
Date: Wed, 24 Sep 2014 23:31:11 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: balbi@ti.com
CC: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        Peter.Chen@freescale.com, stern@rowland.harvard.edu,
        swarren@wwwdotorg.org, thierry.reding@gmail.com,
        linux-tegra@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-sh@vger.kernel.org, yoshihiro.shimoda.uh@renesas.com,
        linux-kernel@vger.kernel.org, antoine.tenart@free-electrons.com
Subject: Re: [PATCH v6 1/2] usb: rename phy to usb_phy in HCD
References: <37148636.BU5lT4M4eC@wasted.cogentembedded.com> <2300651.HNvMzB0aUB@wasted.cogentembedded.com> <20140924192806.GO17997@saruman>
In-Reply-To: <20140924192806.GO17997@saruman>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 09/24/2014 11:28 PM, Felipe Balbi wrote:

>> From: Antoine Tenart <antoine.tenart@free-electrons.com>

>> The USB PHY member of the HCD structure is renamed to 'usb_phy' and
>> modifications are done in all drivers accessing it.
>> This is in preparation to adding the generic PHY support.

>> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
>> [Sergei: added missing 'drivers/usb/misc/lvstest.c' file, resolved rejects,
>> updated changelog.]
>> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
>> Acked-by: Alan Stern <stern@rowland.harvard.edu>

> Acked-by: Felipe Balbi <balbi@ti.com>

    Sorry, forgot to collect your ACK from the previous posting. :-/

WBR, Sergei

