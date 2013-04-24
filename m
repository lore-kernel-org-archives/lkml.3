Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749Ab3DXGkX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 02:40:23 -0400
Received: from mail.windriver.com ([147.11.1.11]:54665 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754Ab3DXGkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 02:40:22 -0400
Message-ID: <51777E4F.9060405@windriver.com>
Date: Wed, 24 Apr 2013 14:40:15 +0800
From: "tiejun.chen" <tiejun.chen@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Anatolij Gustschin <agust@denx.de>
CC: <galak@kernel.crashing.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] usb: ehci-fsl: set INCR8 mode only on MPC512x
References: <1366772110-9620-1-git-send-email-tiejun.chen@windriver.com> <20130424075554.1ae85c65@crub>
In-Reply-To: <20130424075554.1ae85c65@crub>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [147.11.178.22]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2013 01:55 PM, Anatolij Gustschin wrote:
> On Wed, 24 Apr 2013 10:55:10 +0800
> Tiejun Chen <tiejun.chen@windriver.com> wrote:
>
>> commit 761bbcb7, "usb: ehci-fsl: set INCR8 mode for system bus interface
>> on MPC512x", introduced to fix one MPC5121e (M36P) Errata by setting
>> INCR8 mode for system bus interface on MPC512x, but we should make sure
>> this is only valid for MPC512x like other parts of this commit. Otherwise
>
> NAK. It is already only valid for MPC512x.
>
>> this would issue other platforms as abnormal without this similar Errata.
>
> This setting is in the ehci_fsl_mpc512x_drv_resume() function which is
> not called on other platforms.

Yes, I already notice this and also send a notification to ignore this improper 
patch immediately ;-)

Thanks,

Tiejun

