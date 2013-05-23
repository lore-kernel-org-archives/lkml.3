Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758895Ab3EWSVa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 14:21:30 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:54923 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758062Ab3EWSV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 14:21:29 -0400
Message-ID: <519E5E2E.4070104@cogentembedded.com>
Date: Thu, 23 May 2013 22:21:34 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: "B, Ravi" <ravibabu@ti.com>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Balbi, Felipe" <balbi@ti.com>
Subject: Re: [PATCH v1 2/9] usb: musb: nop: remove unused nop_xceiv_(un)register
 APIs from glue
References: <1369288888-8614-1-git-send-email-ravibabu@ti.com> <1369288888-8614-3-git-send-email-ravibabu@ti.com> <519E2612.5000904@cogentembedded.com> <6C6B28D4DC342643927BEAFCE8707BF63EAE3E31@DBDE04.ent.ti.com>
In-Reply-To: <6C6B28D4DC342643927BEAFCE8707BF63EAE3E31@DBDE04.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 05/23/2013 09:07 PM, B, Ravi wrote:

>>> removed unused nop xceiv (un_)register API's from all musb
>>> platform drivers
>>     Since when are they unused?
> Please refer to commit id 662dca54 : usb: otg: support for multiple transceivers by a single controller.
> Usb_get_phy() is used to get the of phy used by controller, phy bindings are done through DT.

    Why are you sure that all these platforms support DT (in all 
configurations)?
It seems to me that you're simply breaking the patched glue layers with 
this patch.
I'll let Felipe decide the fate of this patch though...

>
>>> Signed-off-by: Ravi Babu <ravibabu@ti.com>
> --
> Ravi B

WBR, Sergei

