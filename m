Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756969Ab3EVVfY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 17:35:24 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:64031 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756096Ab3EVVfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 17:35:22 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1305222327300.22195@pobox.suse.cz>
References: <1369257474-26389-1-git-send-email-vpalatin@chromium.org> <alpine.LNX.2.00.1305222327300.22195@pobox.suse.cz>
From: Vincent Palatin <vpalatin@chromium.org>
Date: Wed, 22 May 2013 14:35:01 -0700
X-Google-Sender-Auth: PQf5c6XWu45-kA5yCEmVHDyEazE
Message-ID: <CAP_ceTxhMut6Gewj=WxqAREusK4ZpwOyptAOAm9YT=LvEJcXCQ@mail.gmail.com>
Subject: Re: [PATCH] HID: usbhid: ignore Jabra speakerphones HID interface
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Olof Johansson <olofj@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 2:27 PM, Jiri Kosina <jkosina@suse.cz> wrote:
>
> Please do this in hid_ignore_list[] in drivers/hid/hid-core.c instead.

Thanks for the advice !
I will update the patch accordingly.

-- 
Vincent
