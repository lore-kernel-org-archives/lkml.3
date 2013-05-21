Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab3EUEe7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 00:34:59 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:52494 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab3EUEe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 00:34:58 -0400
MIME-Version: 1.0
In-Reply-To: <1369104127-6284-1-git-send-email-libo.chen@huawei.com>
References: <1369104127-6284-1-git-send-email-libo.chen@huawei.com>
Date: Tue, 21 May 2013 10:04:57 +0530
X-Google-Sender-Auth: lDhad62lGS3mcs8gf94gvVypjyo
Message-ID: <CAOh2x=mihrvyxQdF5J6NsQGQ-a+fGX6Dqr3X2qB1=OrtYZGofg@mail.gmail.com>
Subject: Re: [PATCH 02/19] drivers/usb/host: add missing platform_driver owner
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Libo Chen <libo.chen@huawei.com>
Cc: stern@rowland.harvard.edu, gregkh@linuxfoundation.org, balbi@ti.com,
        sarah.a.sharp@linux.intel.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        lizefan@huawei.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 8:12 AM, Libo Chen <libo.chen@huawei.com> wrote:
> set the owner of platform_driver, to ensure that the
> caller of driver holds a module refernece
>
> Signed-off-by: Libo Chen <libo.chen@huawei.com>
> ---
>  drivers/usb/host/ehci-spear.c   |    1 +

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
