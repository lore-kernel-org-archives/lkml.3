Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933611AbaEMNam (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 09:30:42 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:41237 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383AbaEMNak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 09:30:40 -0400
Message-ID: <53721E7C.3090406@gmail.com>
Date: Tue, 13 May 2014 15:30:36 +0200
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: George Cherian <george.cherian@ti.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org
CC: balbi@ti.com, gregkh@linuxfoundation.org
Subject: Re: [PATCH v3 0/5] Add support for SW babble Control
References: <1399969905-3509-1-git-send-email-george.cherian@ti.com> <5371EA01.3080307@gmail.com> <537208A9.4020507@ti.com> <53720E0F.3070008@gmail.com> <537216AC.4090401@ti.com> <53721ABF.8060705@gmail.com> <53721D24.4090704@ti.com>
In-Reply-To: <53721D24.4090704@ti.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2014 03:24 PM, George Cherian wrote:
> Basically, there are 2 types of babble conditions.
> 1) Transient babble condition - which could be recovered from without an 
> IP reset .
> 2) Babble condition - which could be recovered from only by doing an IP 
> reset.

Ok, thanks for the explanation.

> Looks like you are always hitting case 2 (Most times am also hitting the 
> same).

Seems like, yes.

> There is no 100% reliable method to force it to happen. Following is
> my setup ,
> I have a HUB with 4 devices connected , which gives me a Babble interrupt
> on both connects and disconnects ( Not always though).

I also get them at disconnects, but only with one specific USB device.

But as I don't ever see case 1) above, I can't say if your approach
works. What I can say, though, is that your patches don't break the
recovery from babble conditions that I experienced :)


Daniel
