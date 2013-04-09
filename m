Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964831Ab3DIMcW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 08:32:22 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:43591 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153Ab3DIMcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 08:32:20 -0400
Message-ID: <51640A16.1060002@cogentembedded.com>
Date: Tue, 09 Apr 2013 16:31:18 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Vivek Gautam <gautam.vivek@samsung.com>
CC: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        stern@rowland.harvard.edu, kgene.kim@samsung.com,
        Manjunath Goudar <manjunath.goudar@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH] usb: ehci-s5p: fix: Fix null pointer dereferencing
References: <1365499312-14232-1-git-send-email-gautam.vivek@samsung.com>
In-Reply-To: <1365499312-14232-1-git-send-email-gautam.vivek@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 09-04-2013 13:21, Vivek Gautam wrote:

> 7edb3da makes ehci-s5p as a separate driver. But,

    Please also provide the summary line of that commit in parens.

> it raised an issue with its driver data.
> Now that 's5p_ehci_hcd' doesn't maintain pointer to 'usb_hcd'
> and s5p_ehci is nothing but a pointer to hcd->priv;
> add hcd to the driver data rather than s5p_ehci.

> This fixes issues with null pointer dereferencing in
> s5p_ehci_shutdown(), s5p_ehci_suspend(), s5p_ehci_resume().

> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> CC: Manjunath Goudar <manjunath.goudar@linaro.org>
> CC: Arnd Bergmann <arnd@arndb.de>
> CC: Jingoo Han <jg1.han@samsung.com>

WBR, Sergei


