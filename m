Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130Ab3LDD7H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 22:59:07 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:37323 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098Ab3LDD7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 22:59:05 -0500
Message-ID: <529EA886.8010508@wwwdotorg.org>
Date: Tue, 03 Dec 2013 20:59:02 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Chris Ruehl <chris.ruehl@gtsys.com.hk>, balbi@ti.com
CC: gregkh@linuxfoundation.org, thierry.reding@gmail.com,
        linux-usb@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: Re: [PATCH] usb: phy-tegra-usb.c: wrong pointer check for remap UTMI
References: <1386122564-4246-1-git-send-email-chris.ruehl@gtsys.com.hk>
In-Reply-To: <1386122564-4246-1-git-send-email-chris.ruehl@gtsys.com.hk>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2013 07:02 PM, Chris Ruehl wrote:
> usb: phy-tegra-usb.c: wrong pointer check for remap UTMI
> 
> A wrong pointer was used to test the result of devm_ioremap()
> 
> Signed-off-by: Chris Ruehl <chris.ruehl@gtsys.com.hk>
> Acked-by: Venu Byravarasu <vbyravarasu@nvidia.com>

Out of curiosity, when did that ack happen? I didn't see it. But anyway,

Acked-by: Stephen Warren <swarren@nvidia.com>

