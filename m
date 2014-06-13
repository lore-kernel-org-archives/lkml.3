Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906AbaFMNey (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 09:34:54 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:57626 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbaFMNex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 09:34:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH v2] ARM: Remove ARCH_HAS_CPUFREQ config option
Date: Fri, 13 Jun 2014 15:34:44 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sachin Kamat <spk.linux@gmail.com>
References: <1401819863-20296-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1401819863-20296-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201406131534.44741.arnd@arndb.de>
X-Provags-ID: V02:K0:omz+wsdsdVCSKYTlabfAC/Qiyoi0SgxUqm3y5G0O3oa
 sXTzG4UP5Uy0+vPJ+98tcNw/O5PcpcBTLeHG3QBMKla+GkFlpT
 xfygYuiBNymEy8++GKXOA8bdhu4ouIUSUQi2vsUdzSV37MDGYS
 BxYRpAW0TuAjMsFUe4SGmkPgRALdLW09EVUGjnhHcPHdL5qZwn
 RQkkpdGTP8bZdCfeeKzhafr60Ji98FDWFEeBrWPe1nPwk61uxT
 joLbHkCNH/ZFyG/GUCH6df81lr0minx0WDgdOXW0y2fpnFJNWy
 fAfR1yk+9Didk4Pp7ORKEwOww+YT9gWa+XyYg8a/NkDXQz6Kq2
 Q3N2/f+wr3oMXBQ0gzSg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 June 2014, Stephen Boyd wrote:
> This config exists entirely to hide the cpufreq menu from the
> kernel configuration unless a platform has selected it. Nothing
> is actually built if this config is 'Y' and it just leads to more
> patches that add a select under a platform Kconfig so that some
> other CPUfreq option can be chosen. Let's remove the option so
> that we can always enable CPUfreq drivers on ARM platforms.
> 
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Applied to fixes branch, thanks!

	Arnd
