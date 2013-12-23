Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264Ab3LWL3N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 06:29:13 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:51954 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab3LWL3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 06:29:12 -0500
Date: Mon, 23 Dec 2013 11:26:37 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Libin <huawei.libin@huawei.com>
Cc: <davem@davemloft.net>, <hsweeten@visionengravers.com>,
        <gregkh@linuxfoundation.org>, <tedheadster@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dingtianhong@huawei.com>
Subject: Re: [PATCH] drivers/net: Fix potential incorrect call for udelay()
Message-ID: <20131223112637.46ae42e3@alan.etchedpixels.co.uk>
In-Reply-To: <1387791224-29320-1-git-send-email-huawei.libin@huawei.com>
References: <1387791224-29320-1-git-send-email-huawei.libin@huawei.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Dec 2013 17:33:44 +0800
Libin <huawei.libin@huawei.com> wrote:

> From: Li Bin <huawei.libin@huawei.com>
> 
> The variable delay_time as a module parameter can be set a value
> exceeding the limit of the udelay function. This patch checks the
> delay_time value to select mdelay() or udelay().
> 
> Signed-off-by: Li Bin <huawei.libin@huawei.com>

Nobody should need to set a delay time that long, so this seems a rather
surplus check.

Alan
