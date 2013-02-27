Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774Ab3B0UBD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 15:01:03 -0500
Received: from ns1.pc-advies.be ([83.149.101.17]:37250 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752091Ab3B0UBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 15:01:02 -0500
Date: Wed, 27 Feb 2013 21:00:58 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: linux-kernel@vger.kernel.org, Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Davide Ciminaghi <ciminaghi@gnudd.com>, linus.walleij@linaro.org,
        viresh.kumar@linaro.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org
Subject: Re: [PATCH V6 2/5] watchdog: sp805_wdt depends on ARM
Message-ID: <20130227200058.GD7867@spo001.leaseweb.com>
References: <cover.1361398606.git.rubini@gnudd.com> <1e8486a5ebe77094a970b8a6d72a1cc5a18e2e52.1361398612.git.rubini@gnudd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1e8486a5ebe77094a970b8a6d72a1cc5a18e2e52.1361398612.git.rubini@gnudd.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alessandro,

> The SP805 driver is only used by the Spear machines, and uses
> writel_relaxed, which is not available on all architectures.
> 
> The dependency from CONFIG_ARM avoids compilation problems under
> randomconfig when CONFIG_ARM_AMBA is enabled for x86 builds.
> 
> Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
> Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
> Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
> Acked-by: Wim Van Sebroeck <wim@iguana.be>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>

Added to linux-watchdog-next.

Kind regards,
Wim.

