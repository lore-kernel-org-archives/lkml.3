Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572Ab3LECn5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 21:43:57 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:58888 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515Ab3LECnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 21:43:52 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH 5/5] ARM: msm: Move MSM's DT based hardware to multi-platform support
Date: Thu, 5 Dec 2013 03:43:18 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <1386185952-27259-1-git-send-email-sboyd@codeaurora.org> <1386185952-27259-6-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1386185952-27259-6-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201312050343.19327.arnd@arndb.de>
X-Provags-ID: V02:K0:Wz1zQ/EHj2h/uYlYq0Yh2i/r62LZjF7VAh5g4xBFePe
 pH1V3BjIhcfoYG24nbLfenczDFZuMcNvuPSjCYyvEKpf4rJ5CV
 zVhWTuEVTTg1bt8nHGymcrwLPR9IwLI4+pbbYutv3CLayta9Mj
 X1PgY1TPz4S5MHiUvEFqRWMToAtUqSWZ8JSvozhfWHhj3xoDis
 IB3umAx4JgmLFUQW6+Te2hAlqijkJXDMKpLwkQ58n3vTpZjFzg
 tCz1vMq9eW4CLNB1IpUb62zGGeol102Ds6EHsRdHJCr2ZhSNKU
 QvgMs12IFEA/776wnL9VKWZFl2bsWpBG+TytgNYF+XGGBpKm8Y
 pS8gEHjAYmZBmiYtAC4Q=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 December 2013, Stephen Boyd wrote:
> The DT based MSM platforms can join the multi-platform builds, so
> introduce a DT based ARCH_MSM option. This option allows DT based
> MSM platforms to be built into the multi-platform kernel. Also
> introduce a hidden ARCH_MSM config that both the DT and non-DT
> platform support code select to avoid churn in places that depend
> on CONFIG_ARCH_MSM.
> 
> Cc: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Nice!

Acked-by: Arnd Bergmann <arnd@arndb.de>
