Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965959Ab3E2MGB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 08:06:01 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56071 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965645Ab3E2MF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 08:05:59 -0400
Message-ID: <51A5EF20.6050905@ti.com>
Date: Wed, 29 May 2013 15:05:52 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <gregkh@linuxfoundation.org>, <balbi@ti.com>, <stern@rowland.harvard.edu>,
        <kishon@ti.com>, <adrienverge@gmail.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] USB: PHY: Improve PHY selection logic
References: <1369827811-534-1-git-send-email-rogerq@ti.com> <4843252.ptIdMxoBef@wuerfel>
In-Reply-To: <4843252.ptIdMxoBef@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2013 02:59 PM, Arnd Bergmann wrote:
> On Wednesday 29 May 2013 14:43:26 Roger Quadros wrote:
>>
>> Improve Kconfig so that the relevant PHY driver can be explicitely
>> selected by the controller driver instead of relying on the user
>> to do so.
>>
>> Detailed description in patch 1.
> 
> I think you have to fold patches 3-5 into patch 1, otherwise you
> get a circular dependency between the Kconfig options during
> bisection.
>

You are right. I'll fix that in v2. I'll first wait for more comments
on the overall approach.

cheers,
-roger
