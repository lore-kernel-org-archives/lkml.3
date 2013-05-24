Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab3EXOlp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 10:41:45 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:45357 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab3EXOlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 10:41:44 -0400
Message-ID: <519F7C2E.2060409@cogentembedded.com>
Date: Fri, 24 May 2013 18:41:50 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: "B, Ravi" <ravibabu@ti.com>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Balbi, Felipe" <balbi@ti.com>
Subject: Re: [PATCH v1 2/9] usb: musb: nop: remove unused nop_xceiv_(un)register
 APIs from glue
References: <1369288888-8614-1-git-send-email-ravibabu@ti.com> <1369288888-8614-3-git-send-email-ravibabu@ti.com> <519E2612.5000904@cogentembedded.com> <6C6B28D4DC342643927BEAFCE8707BF63EAE3E31@DBDE04.ent.ti.com> <519E5E2E.4070104@cogentembedded.com> <6C6B28D4DC342643927BEAFCE8707BF63EAE52AA@DBDE04.ent.ti.com>
In-Reply-To: <6C6B28D4DC342643927BEAFCE8707BF63EAE52AA@DBDE04.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 24-05-2013 9:34, B, Ravi wrote:

>>>> removed unused nop xceiv (un_)register API's from all musb platform
>>>> drivers

>>>      Since when are they unused?

>> Please refer to commit id 662dca54 : usb: otg: support for multiple transceivers by a single controller.
>> Usb_get_phy() is used to get the of phy used by controller, phy bindings are done through DT.

>>     Why are you sure that all these platforms support DT (in all configurations)?
>> It seems to me that you're simply breaking the patched glue layers with this patch.
>> I'll let Felipe decide the fate of this patch though...

> You are correct, the bindings of phy and controller need not to done through DT alone, there is a saperate API
> Phy API's available for such bindings done in respective board platform files.

    I don't see any such code in e.g. DaVinci/DA8xx platform files.

>>>> Signed-off-by: Ravi Babu <ravibabu@ti.com>
>> --
>> Ravi B

WBR, Sergei

