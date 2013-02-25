Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419Ab3BYWxZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 17:53:25 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:56188 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932124Ab3BYWxY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 17:53:24 -0500
MIME-Version: 1.0
In-Reply-To: <1361817876-24747-2-git-send-email-serban.constantinescu@arm.com>
References: <1361817876-24747-1-git-send-email-serban.constantinescu@arm.com>
	<1361817876-24747-2-git-send-email-serban.constantinescu@arm.com>
Date: Mon, 25 Feb 2013 14:53:24 -0800
Message-ID: <CAMP5Xgd2avNk-AV_XHQbAAiAz6S9p47Zwo9kUVaP-EcS9ZfbXQ@mail.gmail.com>
Subject: Re: [PATCH] staging: android: ashmem: Add support for 32bit ashmem
 calls in a 64bit kernel
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Serban Constantinescu <serban.constantinescu@arm.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        kernel-team@android.com, john.stultz@linaro.org, Dave.Butcher@arm.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 10:44 AM, Serban Constantinescu
<serban.constantinescu@arm.com> wrote:
> Android's shared memory subsystem, Ashmem, does not support calls from a
> 32bit userspace in a 64 bit kernel. This patch adds support for syscalls
> coming from a 32bit userspace in a 64bit kernel.
>
> The patch has been successfully tested on ARMv8 AEM(64bit
> platform model) and Versatile Express A9(32bit platform).
>
> Signed-off-by: Serban Constantinescu <serban.constantinescu@arm.com>

Acked-by: Arve Hjønnevåg <arve@android.com>
