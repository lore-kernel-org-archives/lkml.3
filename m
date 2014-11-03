Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229AbaKCTAD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 14:00:03 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:53181 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbaKCS77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 13:59:59 -0500
MIME-Version: 1.0
In-Reply-To: <1415033000-28530-1-git-send-email-robotboy@chromium.org>
References: <1414616030-37346-1-git-send-email-robotboy@chromium.org>
	<1415033000-28530-1-git-send-email-robotboy@chromium.org>
Date: Mon, 3 Nov 2014 10:59:59 -0800
X-Google-Sender-Auth: tlbG2FalB72KvLA3zxwBnTASRj8
Message-ID: <CANLzEkswS4rKGhJmkxF95nWWfyVxdv3REr+SmF6smuj_G0JBXg@mail.gmail.com>
Subject: Re: [PATCH] USB: simple: add Google simple serial SubClass support
From: Benson Leung <bleung@chromium.org>
To: Anton Staaf <robotboy@chromium.org>
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Olof Johansson <olofj@chromium.org>, linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 3, 2014 at 8:43 AM, Anton Staaf <robotboy@chromium.org> wrote:
> Add support for Google devices that export simple serial
> interfaces using the vendor specific SubClass/Protocol pair
> 0x50/0x01.
>
> Signed-off-by: Anton Staaf <robotboy@chromium.org>

Reviewed-by: Benson Leung <bleung@chromium.org>




-- 
Benson Leung
Software Engineer, Chrom* OS
bleung@chromium.org
