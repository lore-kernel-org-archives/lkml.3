Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932758Ab3GLKJa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 06:09:30 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:44879 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932111Ab3GLKJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 06:09:28 -0400
Date: Fri, 12 Jul 2013 11:09:23 +0100
From: Gustavo Padovan <gustavo@padovan.org>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        David Herrmann <dh.herrmann@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-bluetooth@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Bluetooth: hidp: remove wrong send_report at init
Message-ID: <20130712100923.GA2065@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Benjamin Tissoires <benjamin.tissoires@gmail.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	David Herrmann <dh.herrmann@gmail.com>,
	Jiri Kosina <jkosina@suse.cz>, linux-bluetooth@vger.kernel.org,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1373550090-30379-1-git-send-email-benjamin.tissoires@redhat.com>
 <1373550090-30379-3-git-send-email-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373550090-30379-3-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

* Benjamin Tissoires <benjamin.tissoires@redhat.com> [2013-07-11 15:41:30 +0200]:

> The USB hid implementation does retrieve the reports during the start.
> However, this implementation does not call the HID command GET_REPORT
> (which would fetch the current status of each report), but use the
> DATA command, which is an Output Report (so transmitting data from the
> host to the device).
> The Wiimote controller is already guarded against this problem in the
> protocol, but it is not conformant to the specification to set all the
> reports to 0 on start.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
>  net/bluetooth/hidp/core.c | 14 --------------
>  1 file changed, 14 deletions(-)

Both patches have been applied to bluetooth-next. Thanks.

	Gustavo
