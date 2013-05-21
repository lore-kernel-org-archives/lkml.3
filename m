Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356Ab3EUD2Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 23:28:16 -0400
Received: from mail-gg0-f170.google.com ([209.85.161.170]:48950 "EHLO
	mail-gg0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab3EUD2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 23:28:15 -0400
Date: Tue, 21 May 2013 00:28:06 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: "marcel@holtmann.org" <marcel@holtmann.org>,
        "johan.hedberg@gmail.com" <johan.hedberg@gmail.com>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH rebased] Bluetooth: Add missing reset_resume dev_pm_ops
Message-ID: <20130521032806.GA12086@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	Shuah Khan <shuah.kh@samsung.com>,
	"marcel@holtmann.org" <marcel@holtmann.org>,
	"johan.hedberg@gmail.com" <johan.hedberg@gmail.com>,
	"linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"shuahkhan@gmail.com" <shuahkhan@gmail.com>
References: <1367250333.4938.20.camel@lorien>
 <20130520230832.GF17712@joana>
 <1369092891.8079.5.camel@lorien>
 <1369098178.11557.3.camel@lorien>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369098178.11557.3.camel@lorien>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shuan,

* Shuah Khan <shuah.kh@samsung.com> [2013-05-21 01:02:58 +0000]:

> Add missing reset_resume dev_pm_ops. Missing reset_resume results in the
> following message after power management device test. This change sets
> reset_resume to btusb_resume().
> 
> [ 2506.936134] btusb 1-1.5:1.0: no reset_resume for driver btusb?
> [ 2506.936137] btusb 1-1.5:1.1: no reset_resume for driver btusb?
> 
> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
> ---
>  drivers/bluetooth/btusb.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
> index 7a7e5f8..1eb90c0 100644
> --- a/drivers/bluetooth/btusb.c
> +++ b/drivers/bluetooth/btusb.c
> @@ -1616,6 +1616,7 @@ static struct usb_driver btusb_driver = {
>  #ifdef CONFIG_PM
>  	.suspend	= btusb_suspend,
>  	.resume		= btusb_resume,
> +	.reset_resume	= btusb_resume,
>  #endif
>  	.id_table	= btusb_table,
>  	.supports_autosuspend = 1,

Patch still doesn't apply, are you sending it with git-send-email?

Applying: Bluetooth: Add missing reset_resume dev_pm_ops
/home/padovan/p/linux-trees/bluetooth-next/.git/rebase-apply/patch:13: trailing whitespace.
        .reset_resume   = btusb_resume,
error: patch failed: drivers/bluetooth/btusb.c:1616
error: drivers/bluetooth/btusb.c: patch does not apply
Patch failed at 0001 Bluetooth: Add missing reset_resume dev_pm_ops

	Gustavo
