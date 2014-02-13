Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872AbaBMIBA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 03:01:00 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:34511 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbaBMIA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 03:00:59 -0500
Date: Thu, 13 Feb 2014 00:00:55 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Weijie Yang <weijie.yang@samsung.com>
cc: gregkh@linuxfoundation.org, anton.vorontsov@linaro.org,
        linux-kernel <linux-kernel@vger.kernel.org>, weijie.yang.kh@gmail.com
Subject: Re: [PATCH] staging: android: lowmemorykiller: set TIF_MEMDIE before
 send kill sig
In-Reply-To: <000001cf288b$41699f40$c43cddc0$%yang@samsung.com>
Message-ID: <alpine.DEB.2.02.1402130000110.11689@chino.kir.corp.google.com>
References: <000001cf288b$41699f40$c43cddc0$%yang@samsung.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Feb 2014, Weijie Yang wrote:

> Set TIF_MEMDIE tsk_thread flag before send kill signal to the
> selected thread. This is to fit a usual code sequence and avoid
> potential race issue.
> 

Ok!

> Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
> ---
>  drivers/staging/android/lowmemorykiller.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>  mode change 100644 => 100755 drivers/staging/android/lowmemorykiller.c
> 

That's bad, we'll want to keep this file with permissions of 0644.
