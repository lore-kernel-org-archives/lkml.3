Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539Ab3DXDUa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 23:20:30 -0400
Received: from mail-vb0-f47.google.com ([209.85.212.47]:40617 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756341Ab3DXDU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 23:20:28 -0400
MIME-Version: 1.0
In-Reply-To: <1366734653-488286-14-git-send-email-arnd@arndb.de>
References: <1366734653-488286-1-git-send-email-arnd@arndb.de>
	<1366734653-488286-14-git-send-email-arnd@arndb.de>
Date: Wed, 24 Apr 2013 08:50:27 +0530
X-Google-Sender-Auth: i81GwE3s-T4UiUb7TtiRlAT-zl0
Message-ID: <CAOh2x=nEqqnPjmSVOMTx1oKvCPmZaGDUAb6sOOmMhJb-XemBCw@mail.gmail.com>
Subject: Re: [PATCH 13/21] misc: mark spear13xx-pcie-gadget as broken
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Pratyush Anand <pratyush.anand@st.com>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Viresh Kumar <viresh.kumar@st.com>,
        Shiraz Hashim <shiraz.hashim@st.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 10:00 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> This driver was merged in 2.6.38 but never actually compiled because
> it depends on the <mach/pcie.h> header that has not made it into the
> kernel. Starting with Linux-3.10, this results in "allyesconfig"
> build errors, since spear13xx can now be enabled with the default
> "multiplatform" platform on ARM. Let's mark it as broken for now.
> If it doesn't get fixed, we can drop it completely.
>
> Cc: Pratyush Anand <pratyush.anand@st.com>
> Cc: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> Cc: Viresh Kumar <viresh.kumar@st.com>
> Cc: Shiraz Hashim <shiraz.hashim@st.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/misc/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

@Pratyush: Please see if we can get it fixed soon.
