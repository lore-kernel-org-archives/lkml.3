Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbaEHIZb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 04:25:31 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:65522 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbaEHIZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 04:25:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Roger <rogerable@realtek.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        micky <micky_ching@realsil.com.cn>, Chris Ball <chris@printf.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, devel@linuxdriverproject.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        Wei WANG <wei_wang@realsil.com.cn>
Subject: Re: [PATCH] mmc: rtsx: usb backend needs LED support
Date: Thu, 08 May 2014 10:25:19 +0200
Message-ID: <4607495.q99siu2peP@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <536B3B6F.1010209@realtek.com>
References: <cover.1398735435.git.micky_ching@realsil.com.cn> <CAPDyKFrA39eFnoy-sAGcAUeDqtB78cvAivV+mmRR5C-tov-9eg@mail.gmail.com> <536B3B6F.1010209@realtek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:s5PD+Yy+wJ/++hQOmdJtFUZ24tZqk5pFpf3BrLEKr82
 zIQpfjO2dZrjRCpyKQ0fgu/ZtRkOTJ0PaMCSuExKnBNfvC9DPr
 hrUXzRSuQKKJxAo29G3zgitFtudMXGzVLCbRzXea3slfA5fWyu
 359ntoQ2yWpOycLvV1kx07PSjyuBDfncLMSG4Fo60gb4V1qJfY
 uCQrYgEoCIpC95eVlKafuD80lCLX8Zjs7QED8cpLAlflxBqhup
 IBXisETtRv/PMRKvj9jfY8AFgxATj/X2Y8AIv46bfZbdQgH8B9
 aEn/MXi0dM75G1yUBGigQwbXr9V85HkiIiapOaFfpw8QdBP/Tc
 l8WX4yAQU0AFUmrYwrTU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 May 2014 16:08:15 Roger wrote:
> 
> Would this patch be merged into linux-next or Lee's mfd.git 
> ib-mfd-mmc-memstick-3.16 branch?

It should get merged into whatever tree holds the existing patches, yes

> By the way, should I resend my version?

Actually I found another issue with it and fixed it up here, let me
send the version that works for me.

	Arnd
