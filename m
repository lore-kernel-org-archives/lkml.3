Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758249Ab3ETXIl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 19:08:41 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:51067 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756026Ab3ETXIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 19:08:39 -0400
Date: Mon, 20 May 2013 20:08:32 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: "marcel@holtmann.org" <marcel@holtmann.org>,
        "johan.hedberg@gmail.com" <johan.hedberg@gmail.com>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH] Bluetooth: Add missing reset_resume dev_pm_ops
Message-ID: <20130520230832.GF17712@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	Shuah Khan <shuah.kh@samsung.com>,
	"marcel@holtmann.org" <marcel@holtmann.org>,
	"johan.hedberg@gmail.com" <johan.hedberg@gmail.com>,
	"linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"shuahkhan@gmail.com" <shuahkhan@gmail.com>
References: <1367250333.4938.20.camel@lorien>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367250333.4938.20.camel@lorien>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shuah,

* Shuah Khan <shuah.kh@samsung.com> [2013-04-29 15:45:34 +0000]:

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

This patch needs rebase on latest bluetooth-next. It doesn't apply anymore.
Please re-send it.

	Gustavo
