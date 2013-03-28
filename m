Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711Ab3C1VU2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 17:20:28 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:53310 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027Ab3C1VU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 17:20:27 -0400
Message-ID: <5154B436.5080700@prisktech.co.nz>
Date: Fri, 29 Mar 2013 10:20:54 +1300
From: Tony Prisk <linux@prisktech.co.nz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stern@rowland.harvard.edu
Subject: Re: [PATCH] usb: ehci: mark unlink_empty_async_suspended() as __maybe_unused
References: <1364362080-8489-1-git-send-email-linux@prisktech.co.nz> <201303282109.47130.arnd@arndb.de> <201303282116.21727.arnd@arndb.de>
In-Reply-To: <201303282116.21727.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/03/13 10:16, Arnd Bergmann wrote:
> On Thursday 28 March 2013, Arnd Bergmann wrote:
>> Patch 4d053fdac3 "usb: ehci: unlink_empty_async_suspended() only used
>> with CONFIG_PM" tried to hide the unlink_empty_async_suspended function
>> inside of an #ifdef to work around an unused function warning.
> Hi Greg,
>
> Apparently the warning is now also in 3.8.5, so you might want to backport
> this fix as well after you send it upstream.
>
> 	Arnd
Grr, my bad - I originally wrote the patch with the forward decl 
#ifdef'd as well, but Alan pointed out that it didn't need to be. I 
thought I recompiled it after the change, but obviously not.

Thanks Arnd,

Regards
Tony P
