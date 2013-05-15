Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758711Ab3EOLzu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 07:55:50 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:33779 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755811Ab3EOLzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 07:55:49 -0400
Message-ID: <519377C4.1040800@cogentembedded.com>
Date: Wed, 15 May 2013 15:55:48 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Libo Chen <clbchenlibo.chen@huawei.com>
CC: grant.likely@linaro.org, rob.herring@calxeda.com,
        linux-mips@linux-mips.org, LKML <linux-kernel@vger.kernel.org>,
        devicetree-discuss@lists.ozlabs.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] usb: omap2430: fix memleak in err case
References: <5192E650.3070303@huawei.com>
In-Reply-To: <5192E650.3070303@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 15-05-2013 5:35, Libo Chen wrote:

> when omap_get_control_dev fail, we should release relational platform_device

    s/fail/fails/, s/relational/related/?

> Signed-off-by: Libo Chen <libo.chen@huawei.com>

    You've posted this to the wrong mailing list, linux-mips; 
devicetree-discuss also seems hardly related.

WBR, Sergei

