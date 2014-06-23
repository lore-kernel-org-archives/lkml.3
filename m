Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240AbaFWNxX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:53:23 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:54795 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886AbaFWNxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:53:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 01/22] pci-dma-compat: Add pci_zalloc_consistent helper
Date: Mon, 23 Jun 2014 15:53:12 +0200
Message-ID: <4279380.YmNJ3E7DEi@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <2248b3ffe86cd8995a809bf7e2871f38039979c1.1403530604.git.joe@perches.com>
References: <cover.1403530604.git.joe@perches.com> <2248b3ffe86cd8995a809bf7e2871f38039979c1.1403530604.git.joe@perches.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:zJ2pNbwjJMb3Y0R5iAS3Alpnp3PzXRLeErXOhQQ7buB
 jwd1CeFGX2oWgsstM+dRLRqh7uuOvKltmIN1XNqGv6eqNt+Vvo
 pJr97RcIK02hHv0oxnlFzTJSQQV56fCeRMyg2sYpjORcB7mh1Q
 nd2oH5GDsVVu/OUDRSVgTvl67S9l4smZNtqHT/COq7H28lXKEe
 PnBZILwwzIWGwZFO1FqPRPi+0i+bH6vdKCsPXTvsW66jaz14bb
 3vZuin1HC+t8rnMALQ3Q8JsukamG5EycXqA9EZ/zn0u/p689h2
 LMjF0qbl5aRxg1pao55+VJTbvFedBo/lsLEPHo0ZhVndGACzPL
 ZeFKcrO6EaLIphQCHv0c=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 June 2014 06:41:29 Joe Perches wrote:
> Add this helper for consistency with pci_zalloc_coherent
> and the ability to remove unnecessary memset(,0,) uses.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 

Shouldn't these drivers just use the normal dma-mapping API now?

	Arnd
