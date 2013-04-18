Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936419Ab3DRQjM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 12:39:12 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:34749 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936298Ab3DRQjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 12:39:08 -0400
Date: Thu, 18 Apr 2013 09:39:09 -0700
From: Olof Johansson <olof@lixom.net>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "arm@kernel.org" <arm@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Barry Song <baohua.song@csr.com>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Tony Lindgren <tony@atomide.com>, John Stultz <john.stultz@linaro.org>,
        "Brown, David" <davidb@quicinc.com>
Subject: Re: [PATCHv4 00/11] Remove ARM local timer API
Message-ID: <20130418163909.GH7083@quad.lixom.net>
References: <1365456453-16297-1-git-send-email-sboyd@codeaurora.org>
 <516F09AA.2000902@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <516F09AA.2000902@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 17, 2013 at 01:44:26PM -0700, Stephen Boyd wrote:
> Thomas,
> 
> Would you be able to pick up patches 1 and 2 from this series and
> publish it as a stable branch? Preferably based on rc5 but I can always
> merge it to rc5 and apply the rest of the patches.
> 
> Arnd/Olof,
> 
> Would you be able to merge in the rest of the patches to arm-soc? I can
> provide a branch on 3.9-rc5 and a merge resolution with for-next in
> arm-soc that you can pull to look at.
> 
> If not I will have to resend the series.

Hi,

I think this is 3.11 material at this point, so please send a fresh pull
request (or re-ask us to apply it) after -rc1.


-Olof
