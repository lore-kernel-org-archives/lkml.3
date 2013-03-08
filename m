Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933201Ab3CHVKM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 16:10:12 -0500
Received: from casper.infradead.org ([85.118.1.10]:36663 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932716Ab3CHVKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 16:10:10 -0500
Message-ID: <513A53C9.6020606@infradead.org>
Date: Fri, 08 Mar 2013 13:10:33 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: holtek: Holtek devices depends on USB_HID
References: <1362649709-9608-1-git-send-email-benjamin.tissoires@redhat.com> <513A4FA2.6070309@infradead.org> <alpine.LNX.2.00.1303082159140.19460@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1303082159140.19460@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/13 13:00, Jiri Kosina wrote:
> On Fri, 8 Mar 2013, Randy Dunlap wrote:
> 
>>> In the HID drivers tranport cleanup series, I removed the dependency
>>> between hid-holtek and usbhid. This was wrong as hid-holtek.c relies
>>> extensively on usb calls.
>>>
>>> This fixes compilation error when CONFIG_USB_SUPPORT is not enabled.
>>>
>>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>>
>> Acked-by: Randy Dunlap <rdunlap@infradead.org>
>>
>>
>> but hid-multitouch build still fails (on 3.9-rc1) when USB_SUPPORT is not enabled:
> 
> Are you sure about 3.9-rc1? It has USB_HID dependency for HID_MUTLTIOUCH, 
> hence that shouldn't be a problem.

You are correct.  I was testing 3.9-rc1 + mmotm, where the latter contains
some incorrect HID patches (from linux-next).

Thanks.

> There used to be a problem in linux-next, but that should be fixed by 
> 4ba25d3f87 ("HID: multitouch: remove last usb dependency"), which I have 
> pushed out yesterday.
> 


-- 
~Randy
