Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020AbaGVQAH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 12:00:07 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:36450 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755703AbaGVQAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 12:00:04 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <53CE556C.10607@st.com>
References: <1401899424-1365-1-git-send-email-peter.griffin@linaro.org>
	<1401899424-1365-11-git-send-email-peter.griffin@linaro.org>
	<53A80754.9000900@st.com>
	<53CE556C.10607@st.com>
Date: Tue, 22 Jul 2014 09:00:02 -0700
Message-ID: <CAOesGMhEnwGJR+SgM6XJhW9WT5LAo_-Hxd+kfQHBz7thu+QFJA@mail.gmail.com>
Subject: Re: [STLinux Kernel] [PATCH v3 10/10] MAINTAINERS: Add sdhci-st file
 to ARCH/STI architecture
From: Olof Johansson <olof@lixom.net>
To: Maxime Coquelin <maxime.coquelin@st.com>
Cc: Peter Griffin <peter.griffin@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        Patrice CHOTARD <patrice.chotard@st.com>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "kernel@stlinux.com" <kernel@stlinux.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 5:13 AM, Maxime Coquelin <maxime.coquelin@st.com> wrote:
> Hi Olof, Arnd, Kevin,
>
>         I am preparing two tags for v3.17 regarding STi platform.
>         One for DT, and one for defconfigs.
>
>         Except this one, I have no patches for ARM-SoC.
>         Can you take this patch directly?
>
>         Or should I send a pull request with this one only?

We can apply directly. I'll do that in a moment here.


-Olof
