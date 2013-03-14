Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750940Ab3CNECM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 00:02:12 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:39335 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab3CNECK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 00:02:10 -0400
MIME-Version: 1.0
In-Reply-To: <1363216626-16693-1-git-send-email-gheorghiuandru@gmail.com>
References: <1363216626-16693-1-git-send-email-gheorghiuandru@gmail.com>
Date: Thu, 14 Mar 2013 09:32:09 +0530
Message-ID: <CAK9yfHxYzZ+tBpPfkHHzs9RocuiOuyCZeoEYveH1SQSHDPG1xg@mail.gmail.com>
Subject: Re: [PATCH] drivers: dma: Use devm_ioremap_resource
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 March 2013 04:47, Alexandru Gheorghiu <gheorghiuandru@gmail.com> wrote:
> Replaced call to devm_request_and_ioremap with devm_ioremap_resource which
> provides better error handling.
>
> Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
> ---

Already sent a similar patch to do this:
https://patchwork.kernel.org/patch/2211801/
