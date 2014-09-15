Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515AbaIOSRl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 14:17:41 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35971 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495AbaIOSRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 14:17:38 -0400
Date: Mon, 15 Sep 2014 14:17:35 -0400 (EDT)
Message-Id: <20140915.141735.2081988681960673592.davem@davemloft.net>
To: rickard_strandqvist@spectrumdigital.se
Cc: jdmason@kudzu.us, ebiederm@xmission.com, jg1.han@samsung.com,
        agordeev@redhat.com, benoit.taine@lip6.fr, manuel.schoelling@gmx.de,
        bhutchings@solarflare.com, john.stultz@linaro.org, cengelma@gmx.at,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: neterion: vxge: vxge-main.c: Cleaning
 up missing null-terminate in conjunction with strncpy
From: David Miller <davem@davemloft.net>
In-Reply-To: <1410716087-16154-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1410716087-16154-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 15 Sep 2014 11:17:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Sun, 14 Sep 2014 19:34:47 +0200

> Replacing strncpy with strlcpy to avoid strings that lacks null terminate.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Applied.
