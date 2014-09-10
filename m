Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158AbaIJN4J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 09:56:09 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:41677 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737AbaIJN4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 09:56:06 -0400
MIME-Version: 1.0
In-Reply-To: <2073138.qpVRy5Xj3H@avalon>
References: <1405497009-20338-1-git-send-email-wangxfdu@gmail.com>
	<5513748.05vsM1lCJN@avalon>
	<2073138.qpVRy5Xj3H@avalon>
Date: Wed, 10 Sep 2014 15:56:05 +0200
Message-ID: <CAPDyKFrZ01inaJv+OZCT4hsxksMRN9StDK4mS4KtmK5tNv=tUg@mail.gmail.com>
Subject: Re: [PATCH] mmc: sdhci-pxav3: fix error handling of sdhci_add_host
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Xiang Wang <wangxfdu@gmail.com>, Xiang Wang <wangx@marvell.com>,
        Chris Ball <chris@printf.net>, Marcin Wojtas <mw@semihalf.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chao Xie <cxie4@marvell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 September 2014 15:24, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> On Wednesday 16 July 2014 11:53:21 Laurent Pinchart wrote:
>> On Wednesday 16 July 2014 15:50:09 Xiang Wang wrote:
>> > From: Xiang Wang <wangx@marvell.com>
>> >
>> > Commit 0dcaa2499b7d111bd70da5b0976c34210c850fb3 improved error
>> > handling of sdhci_add_host. However, "err_of_parse" and "err_cd_req"
>> > should be placed after "pm_runtime_disable(&pdev->dev)".
>> >
>> > Signed-off-by: Xiang Wang <wangx@marvell.com>
>>
>> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>
> I can't find the patch in mainline, has it been lost somewhere ?

It was lost, but now found, resolved a conflict for it and queued for 3.18.

Thanks for the reminder!

Kind regards
Uffe
