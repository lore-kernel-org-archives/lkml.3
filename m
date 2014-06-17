Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965825AbaFQQvA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:51:00 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:23644 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964908AbaFQQu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:50:57 -0400
X-AuditID: cbfee61a-b7fef6d00000200b-28-53a071ee876c
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kumar Gala <galak@codeaurora.org>
Cc: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH v2 2/3] ata: Add Qualcomm ARM SoC AHCI SATA host controller
 driver
Date: Tue, 17 Jun 2014 18:50:01 +0200
Message-id: <3066194.ZkIxk6z9u6@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <419989CC-5106-4AF7-8911-617B51FD7395@codeaurora.org>
References: <1402676163-31574-1-git-send-email-galak@codeaurora.org>
 <14174621.WL9ndpHQ2Q@amdc1032>
 <419989CC-5106-4AF7-8911-617B51FD7395@codeaurora.org>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=windows-1252
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCLMWRmVeSWpSXmKPExsVy+t9jQd13hQuCDRpWC1j0v1nIarHp8TVW
	i4n7z7JbHNvxiMni8q45bBY/znSzWPxafpTRgd3jcl8vk8emVZ1sHpuX1Ht83iQXwBLFZZOS
	mpNZllqkb5fAlfH6xgLWgkXsFe1P+lgbGO+xdjFyckgImEj8PfqdEcIWk7hwbz1bFyMXh5DA
	dEaJluMXmEASQgItTBJ3rhuB2GwCVhIT21eBNYgIqEosn7uZBaSBWeAao8SKX5/ZQRLCAhES
	7dMegzWzABVtaZgMZvMKaErMPXMYrEZUwFNix/aVbCA2p4CTxNSrS6GWzWWU+PxYGKJeUOLH
	5HssIDazgLzEvv1Tga7mALL1JO5f1JrAKDALSdUsJFWzEKoWMDKvYhRNLUguKE5KzzXUK07M
	LS7NS9dLzs/dxAgO62dSOxhXNlgcYhTgYFTi4eXIXRAsxJpYVlyZe4hRgoNZSYT3XBZQiDcl
	sbIqtSg/vqg0J7X4EKM0B4uSOO+BVutAIYH0xJLU7NTUgtQimCwTB6dUA6PS3kl1rnL5Z6yE
	HQUmfXv06sO7tqf75vfPeO7KKjp5u2nmruiN0g2C23NKvsasWGieu9mtRnZN7MwJq2UyN4rc
	M9j0YvX+pes6tH+Xr5kqxeN23H6J85unOvNWly4x9JbMl5ypslLsIYftAQ+uh1HN6cauZ32U
	3SX/T5j6d1dVbaXvpbwNHc+UWIozEg21mIuKEwE4ysCXZwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 17, 2014 10:42:36 AM Kumar Gala wrote:
> 
> On Jun 17, 2014, at 7:25 AM, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com> wrote:

[...]

> >> +static struct platform_driver qcom_ahci_driver = {
> >> +	.probe = qcom_ahci_probe,
> >> +	.remove = ata_platform_remove_one,
> >> +	.driver = {
> >> +		.name = "qcom_ahci_qcom",
> >> +		.owner = THIS_MODULE,
> >> +		.of_match_table = qcom_ahci_of_match,
> >> +	},
> > 
> > This driver lacks PM suspend/resume support.  I assume that
> > the IPQ806x platform also doesn't support suspend/resume yet
> > (if so a comment in the driver code about this would be useful),
> > otherwise the driver should be fixed.
> 
> Correct, do you want the comment in the commit message or the driver itself?

I would prefer the comment in the driver itself.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

