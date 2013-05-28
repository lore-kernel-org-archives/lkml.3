Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964866Ab3E1Rk3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 13:40:29 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:59127 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964848Ab3E1Rk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 13:40:28 -0400
Message-ID: <51A4EC0A.2060506@cogentembedded.com>
Date: Tue, 28 May 2013 21:40:26 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Libo Chen <clbchenlibo.chen@huawei.com>
CC: balbi@ti.com, gregkh@linuxfoundation.org, grant.likely@linaro.org,
        rob.herring@calxeda.com, Li Zefan <lizefan@huawei.com>,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] usb: omap2430: fix memleak in err case
References: <5192E650.3070303@huawei.com> <519C3BD1.6050307@huawei.com>
In-Reply-To: <519C3BD1.6050307@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 22-05-2013 7:30, Libo Chen wrote:

> when omap_get_control_dev faild, we should release related platform_device

> * Changelog from v1:
> 	* fix spell: s/fail/fails/, s/relational/related/ , thank Sergei <sergei.shtylyov@cogentembedded.com>

    It seems you've actually replaced "fail" with "faild", not "fails".

> Signed-off-by: Libo Chen <libo.chen@huawei.com>
> ---
>   drivers/usb/musb/omap2430.c |    3 ++-
>   1 files changed, 2 insertions(+), 1 deletions(-)

WBR, Sergei

