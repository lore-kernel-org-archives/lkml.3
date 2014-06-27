Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315AbaF0X6h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 19:58:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48666 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754162AbaF0X6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 19:58:35 -0400
Message-ID: <53AE0519.8050909@zytor.com>
Date: Fri, 27 Jun 2014 16:58:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Find correct 64 bit ramdisk address for microcode
 early update
References: <1402463064-31697-1-git-send-email-yinghai@kernel.org>
In-Reply-To: <1402463064-31697-1-git-send-email-yinghai@kernel.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2014 10:04 PM, Yinghai Lu wrote:
> When using kexec with 64bit kernel, bzImage and ramdisk could be
> loaded above 4G. We need this to get correct ramdisk adress.
> 
> Make get_ramdisk_image() global and use it for early microcode updating.
> Also make it to take boot_params pointer for different usage.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Please update your patch description to explain what "different usage"
you have in mind here.

	-hpa


