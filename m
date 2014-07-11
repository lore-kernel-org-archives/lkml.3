Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbaGKLiM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 07:38:12 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:41744 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbaGKLiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 07:38:10 -0400
Date: Fri, 11 Jul 2014 12:38:04 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Maxime Coquelin <maxime.coquelin@st.com>
Cc: Peter Griffin <peter.griffin@linaro.org>, kernel@stlinux.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [STLinux Kernel] [PATCH v3 0/5] phy: miphy365x: Introduce
 support for MiPHY365x
Message-ID: <20140711113804.GA2954@lee--X1>
References: <1404906074-31992-1-git-send-email-lee.jones@linaro.org>
 <53BD572C.4060406@ti.com>
 <20140710153548.GB26886@griffinp-ThinkPad-X1-Carbon-2nd>
 <20140711103104.GC30519@lee--X1>
 <20140711110547.GA23439@griffinp-ThinkPad-X1-Carbon-2nd>
 <20140711113037.GD30519@lee--X1>
 <53BFCB83.8020304@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53BFCB83.8020304@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2014, Maxime Coquelin wrote:
> On 07/11/2014 01:30 PM, Lee Jones wrote:
> >On Fri, 11 Jul 2014, Peter Griffin wrote:
> >>On Fri, 11 Jul 2014, Lee Jones wrote:
> >>>>One small point, patch 5 which adds the DT nodes may not apply as the file got
> >>>>renamed from stih416-b2020-revE.dts to stih416-b2020e.dts.
> >>>
> >>>Not required, Git should handle this seamlessly.
> >>
> >>I didn't ask you to do anything.
> >
> >Ah, I misread, my bad.
> >
> >>Also when I made the same mistake, GIT
> >>did not handle it seamlessly and I got the following query
> >>from Ulf http://www.mail-archive.com/devicetree@vger.kernel.org/msg33926.html
> >
> >Oh, it looks like the renaming patch went into -rc3 as part of Max's
> >-fixes branch.  I assumed it would go in via -next.  This is
> >different, so yes, it will have to be rebased onto -rc3.
> >
> >Maxime,
> >   Do you want me to do that, or are you happy to?
> 
> Actually, I already rebase the next branch for DT stuff on top of -rc3.
> This is not available on stlinux git yet because of mirroring issue.
> I will let you know when this is fixed, then you can rebase your DT
> patches on top of it.

I'll rebase onto -rc3 now and submit the patch as a vX+1.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
