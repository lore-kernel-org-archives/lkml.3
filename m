Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934895AbaKMVlV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:41:21 -0500
Received: from mail-oi0-f41.google.com ([209.85.218.41]:42026 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934734AbaKMVlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:41:17 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1411131611001.945-100000@iolanthe.rowland.org>
References: <CANLzEksGg0KyWOS+WYv_U8GzSJ4C_H0LTpdXvz8Ae-8mH6K41w@mail.gmail.com>
	<Pine.LNX.4.44L0.1411131611001.945-100000@iolanthe.rowland.org>
Date: Thu, 13 Nov 2014 13:41:16 -0800
X-Google-Sender-Auth: hxOv-1K-oBaMbh2JculxcyHqINo
Message-ID: <CANLzEktsBvmX7Nbn=+JBq6A=cowqnFVPJ1ymQjbv4dgrDvSLFA@mail.gmail.com>
Subject: Re: [PATCH] HID: usbhid: get/put around clearing needs_remote_wakeup
From: Benson Leung <bleung@chromium.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: johan@kernel.org, Jiri Kosina <jkosina@suse.cz>, linux-usb@vger.kernel.org,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sameer Nanda <snanda@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 1:18 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> If you interchange the two lines then the flag _will_ be cleared before
> usb_kill_urb() and autosuspend_check() can run.  This means your patch
> description is bogus.

Gotcha. v2 posted. Thanks for the direction.

-- 
Benson Leung
Software Engineer, Chrom* OS
bleung@chromium.org
