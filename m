Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003AbaGVQRI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 12:17:08 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:64414 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755486AbaGVQRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 12:17:06 -0400
Date: Tue, 22 Jul 2014 09:17:32 -0700
From: Olof Johansson <olof@lixom.net>
To: Maxime Coquelin <maxime.coquelin@st.com>
Cc: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kernel@stlinux.com, arm@kernel.org
Subject: Re: [PATCH 2/2] ARM: multi_v7_defconfig: Enable MiPHY365x - ST's
 Generic (SATA & PCIe) PHY
Message-ID: <20140722161732.GB31092@quad.lixom.net>
References: <1406021985-8763-1-git-send-email-lee.jones@linaro.org>
 <1406021985-8763-2-git-send-email-lee.jones@linaro.org>
 <20140722160630.GA31092@quad.lixom.net>
 <53CE8E14.9020206@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53CE8E14.9020206@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 06:15:16PM +0200, Maxime Coquelin wrote:
> Hi Olof,
> 
> On 07/22/2014 06:06 PM, Olof Johansson wrote:
> >On Tue, Jul 22, 2014 at 10:39:45AM +0100, Lee Jones wrote:
> >>Signed-off-by: Lee Jones <lee.jones@linaro.org>
> >
> >Appled both. In the future, feel free to batch them up in one commit,
> >no need to keep them separate since they're related.
> 
> I added both to the pull request for defconfig I sent this afternoon.
> Not an issue?

Yes, that's an issue.

If you comment on a patch you apply, then others will know that you have picked
it up.

I've dropped the versions I applied now so that we don't get duplicate commits
when I merge your branch.


-Olof

