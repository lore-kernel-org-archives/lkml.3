Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935858Ab3DIS5k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 14:57:40 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:50276 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935623Ab3DIS5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 14:57:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 5/8] dmaengine: ste_dma40: Ensure src and dst registers are configured correctly
Date: Tue, 9 Apr 2013 20:57:29 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com
References: <1365532783-27425-1-git-send-email-lee.jones@linaro.org> <1365532783-27425-5-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1365532783-27425-5-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304092057.29684.arnd@arndb.de>
X-Provags-ID: V02:K0:XgWWOY4b8WQfxjkX1do/Nxr6F8syGktgkTu6BCZ6fiu
 zxSWxZxM0SXmebJHt21/vCBYRtEgg+ev1IcPlodPWVJg1LzbM+
 CkbxQroyTnHipJMZN/xrTKaq0maX6NzWTFGKJbzbW/29cYEpZZ
 RM4zGxpNab4zH8O9xoTbcaVswIQE8NvuLHZIA3FEFPmQL19fnx
 h3dTyl+tEE3B8nHIM7ZmotC/OfXjxNahPAjTx+he8W2BgKUU9U
 X90zg2XsJAFWORxY7SBr9dJxLvNdEW+rCJrRC+SsTr4o8Khmkc
 H86tyJAjG5Uudw0H5WJsDhWODt/D3tK2QpA5QfFUEvHivdJqG/
 qvRYnIyh/DuKhFmb2o3M=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 April 2013, Lee Jones wrote:
> Confusingly d40_log_cfg() is used to set up the logical channel
> configuration registers, but d40_phy_cfg() is used to configure
> physical and logical registers, so it should be called in both
> cases. It is the function call's final attribute which determines
> whether it's a physical or logical channel, not whether the
> function is called or not.

So how did it ever work? Your description sounds like it was
broken all along, but I would assume that someone tested the code.

	Arnd
