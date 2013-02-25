Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759316Ab3BYSzd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 13:55:33 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:38639 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758108Ab3BYSzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 13:55:32 -0500
Message-ID: <512BB3A0.1030101@linaro.org>
Date: Mon, 25 Feb 2013 10:55:28 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Serban Constantinescu <serban.constantinescu@arm.com>
CC: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        kernel-team@android.com, arve@android.com, Dave.Butcher@arm.com
Subject: Re: [PATCH] staging: android: ashmem: Add support for 32bit ashmem
 calls in a 64bit kernel
References: <staging: android: ashmem: add 32bit compat support> <1361817876-24747-1-git-send-email-serban.constantinescu@arm.com> <1361817876-24747-2-git-send-email-serban.constantinescu@arm.com>
In-Reply-To: <1361817876-24747-2-git-send-email-serban.constantinescu@arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2013 10:44 AM, Serban Constantinescu wrote:
> Android's shared memory subsystem, Ashmem, does not support calls from a
> 32bit userspace in a 64 bit kernel. This patch adds support for syscalls
> coming from a 32bit userspace in a 64bit kernel.
>
> The patch has been successfully tested on ARMv8 AEM(64bit
> platform model) and Versatile Express A9(32bit platform).
>
> Signed-off-by: Serban Constantinescu <serban.constantinescu@arm.com>

Acked-by: John Stultz <john.stultz@linaro.org>


thanks
-john
