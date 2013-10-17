Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037Ab3JQNqI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 09:46:08 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:40170 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755660Ab3JQNqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 09:46:06 -0400
Message-ID: <525FEA03.50407@ti.com>
Date: Thu, 17 Oct 2013 09:45:39 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Grygorii Strashko <grygorii.strashko@ti.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        open list <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Kevin Hilman <khilman@linaro.org>,
        Taras Kondratiuk <taras.kondratiuk@linaro.org>
Subject: Re: [PATCH 1/2] Revert "ARM: OMAP4+: CPUidle: Deprecate use of omap4_mpuss_read_prev_context_state()"
References: <1382000776-15897-2-git-send-email-grygorii.strashko@ti.com> <525FACB7.9000903@ti.com>
In-Reply-To: <525FACB7.9000903@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 October 2013 05:24 AM, Grygorii Strashko wrote:
> The same workaround as ff999b8a0983ee15668394ed49e38d3568fc6859
> "ARM: OMAP4460: Workaround for ROM bug because of CA9 r2pX GIC control register change."
> need to be applied not only when system is booting, but when MPU hits OSWR state through CPUIdle too.
> 
> Unfortunately, commit "ARM: OMAP4+: CPUidle: Deprecate use of
> omap4_mpuss_read_prev_context_state()" prevents us from implementing workaround
> for this ROM code bug, because it should be applied only (and only)
> when MPU really hits OSWR and its was lost context.
> 
> Hence revert commit e7457253494fff660a72bc0cedeee97491ccd173
> "ARM: OMAP4+: CPUidle: Deprecate use of omap4_mpuss_read_prev_context_state()".
> 
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Cc: Kevin Hilman <khilman@linaro.org>
> Reported-and-Tested-by: Taras Kondratiuk <taras.kondratiuk@linaro.org>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---
NAK.. Lets not add this which will make the code
movement to drivers/idle difficult. This can be handled..
See comments on 2/2.

Regards,
Santosh

