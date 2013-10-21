Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329Ab3JUKyG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 06:54:06 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:14189 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246Ab3JUKyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 06:54:03 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 21 Oct 2013 03:49:25 -0700
Message-ID: <52650E2E.7010106@nvidia.com>
Date: Mon, 21 Oct 2013 16:51:18 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: George Cherian <george.cherian@ti.com>
CC: "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        "cw00.choi@samsung.com" <cw00.choi@samsung.com>,
        "kishon@ti.com" <kishon@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] extcon: palmas: Handle ID interrupt properly using USB_ID_INT_SRC
References: <1381430919-4635-1-git-send-email-george.cherian@ti.com> <525CC725.7060508@ti.com>
In-Reply-To: <525CC725.7060508@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 October 2013 10:10 AM, George Cherian wrote:
> Laxman/Chanwoo/Kishon,
>
> Any comments on this!!
> Regards
> -George
> On 10/11/2013 12:18 AM, George Cherian wrote:
>> Always cross check with the ID state and the source of interrupt.
>> Also add a case in which ID Source is ID_GND but LATCH state is set
>> wrongly. This uses the previous Link stat to determine the new state.
>>

Looks good to me.
Acked-by: Laxman Dewangan <ldewangan@nvidia.com>
