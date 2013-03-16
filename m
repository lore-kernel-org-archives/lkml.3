Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab3CQSQK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 14:16:10 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:42857 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755766Ab3CQSQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 14:16:09 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: Re: [PATCH] usb: cdc-acm: fix error handling in acm_probe()
Date: Sat, 16 Mar 2013 09:35:26 +0100
Message-ID: <26741491.YAe6gssxWn@linux-5eaq.site>
User-Agent: KMail/4.8.5 (Linux/3.8.0-rc7-12-desktop+; KDE/4.8.5; x86_64; ; )
In-Reply-To: <1363383032-13257-1-git-send-email-khoroshilov@ispras.ru>
References: <1363383032-13257-1-git-send-email-khoroshilov@ispras.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 16 March 2013 01:30:32 Alexey Khoroshilov wrote:
> acm_probe() ignores errors in tty_port_register_device()
> and leaves intfdata pointing to freed memory on alloc_fail7
> error path. The patch fixes the both issues.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Acked-by: Oliver Neukum <oliver@neukum.org>

