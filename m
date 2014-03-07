Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771AbaCGV2E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 16:28:04 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:42706 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbaCGV2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 16:28:00 -0500
From: Christian Lamparter <chunkeey@googlemail.com>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: Re: [PATCH] p54usb: fix leaks at failure path in p54u_probe()
Date: Fri, 07 Mar 2014 22:27:34 +0100
Message-ID: <2146611.esrnhmtufH@debian64>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc4-wl+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1394226709-10763-1-git-send-email-khoroshilov@ispras.ru>
References: <1394226709-10763-1-git-send-email-khoroshilov@ispras.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, March 08, 2014 01:11:49 AM Alexey Khoroshilov wrote:
> If p54u_load_firmware() fails, p54u_probe() does not deallocate
> already allocated resources. The patch adds proper failure handling.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Acked-by: Christian Lamparter <chunkeey@googlemail.com>

