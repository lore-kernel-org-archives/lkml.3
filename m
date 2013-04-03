Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761607Ab3DCMVW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 08:21:22 -0400
Received: from ra.se.axis.com ([195.60.68.13]:37456 "EHLO ra.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761888Ab3DCMVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 08:21:17 -0400
Date: Wed, 3 Apr 2013 14:21:09 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "rjw@sisk.pl" <rjw@sisk.pl>,
        "arvind.chauhan@arm.com" <arvind.chauhan@arm.com>,
        "robin.randhawa@arm.com" <robin.randhawa@arm.com>,
        "Steve.Bannister@arm.com" <Steve.Bannister@arm.com>,
        "Liviu.Dudau@arm.com" <Liviu.Dudau@arm.com>,
        "charles.garcia-tobin@arm.com" <charles.garcia-tobin@arm.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "arnd.bergmann@linaro.org" <arnd.bergmann@linaro.org>,
        Jesper Nilsson <jespern@axis.com>, Mikael Starvik <starvik@axis.com>,
        linux-cris-kernel <linux-cris-kernel@axis.com>
Subject: Re: [PATCH 3/9] cris: cpufreq:  move cpufreq driver to
 drivers/cpufreq
Message-ID: <20130403122109.GM19150@axis.com>
References: <cover.1364229828.git.viresh.kumar@linaro.org>
 <ba21f31410c122d160698a6d18266e3f695f6011.1364229828.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ba21f31410c122d160698a6d18266e3f695f6011.1364229828.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 25, 2013 at 05:54:39PM +0100, Viresh Kumar wrote:
> This patch moves cpufreq drivers of CRIS architecture to drivers/cpufreq.
> 
> Cc: Jesper Nilsson <jesper.nilsson@axis.com>
> Cc: Mikael Starvik <starvik@axis.com>
> Cc: linux-cris-kernel@axis.com
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Ah, sorry for not responding earlier, looks good!

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
