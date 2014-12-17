Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838AbaLQLfg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 06:35:36 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:59317 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbaLQLfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 06:35:34 -0500
Message-ID: <54916A82.4010105@cogentembedded.com>
Date: Wed, 17 Dec 2014 14:35:30 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Peter Chen <Peter.Chen@freescale.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
CC: "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: hcd: add OTG ID signal sensing
References: <3663198.HSrURZGche@wasted.cogentembedded.com> <BN3PR0301MB08495DD76B65E14BDE460E42816D0@BN3PR0301MB0849.namprd03.prod.outlook.com>
In-Reply-To: <BN3PR0301MB08495DD76B65E14BDE460E42816D0@BN3PR0301MB0849.namprd03.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 12/17/2014 5:08 AM, Peter Chen wrote:

>> On the Renesas R8A7791 SoC based boards there's MAX3355 USB OTG chip and
>> mini-AB USB connector corresponding to USB port 0 driven either by EHCI/OHCI
>> or  Renesas USBHS gadget controller. And we'd like the  host/gadget drivers to
>> work based on the cable type connected. An 'extcon' driver for MAX3355 has
>> been written, so we only need to bind  to it via device tree which I'm doing in
>> this patch.

>> I wasn't able to find a solution better than checking the cable type at the host
>> driver probe time and refusing to drive a host if B-cable is connected.

> You may need a dual-role/otg driver to do it, which can enable host/device function
> according to ID pin.

    It would have been too good if I had a dual-role controller. :-)
    But I have what I have. IIUC, such configuration (OHCI and UDC sharing a 
USB port) has been used on OMAP1.

WBR, Sergei

