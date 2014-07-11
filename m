Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360AbaGKLel (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 07:34:41 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:55284 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbaGKLej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 07:34:39 -0400
Date: Fri, 11 Jul 2014 12:34:33 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Peter Griffin <peter.griffin@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com
Subject: Re: [STLinux Kernel] [PATCH v3 0/5] phy: miphy365x: Introduce
 support for MiPHY365x
Message-ID: <20140711113433.GE30519@lee--X1>
References: <1404906074-31992-1-git-send-email-lee.jones@linaro.org>
 <53BD572C.4060406@ti.com>
 <20140710153548.GB26886@griffinp-ThinkPad-X1-Carbon-2nd>
 <20140711103104.GC30519@lee--X1>
 <20140711110547.GA23439@griffinp-ThinkPad-X1-Carbon-2nd>
 <53BFC6F4.2060804@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53BFC6F4.2060804@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2014, Kishon Vijay Abraham I wrote:
> On Friday 11 July 2014 04:35 PM, Peter Griffin wrote:
> > On Fri, 11 Jul 2014, Lee Jones wrote:
> >>> One small point, patch 5 which adds the DT nodes may not apply as the file got
> >>> renamed from stih416-b2020-revE.dts to stih416-b2020e.dts.
> >>
> >> Not required, Git should handle this seamlessly.

[...]

> Your cover letter did not have the patch subjects. When you send the next
> version can you use --cover-letter option to create the cover letter?

Using --annotate and --compose has done me well up until now and no
one has ever complained before.  But yes, I can use --cover-letter if
having the list of patch subjects in the 0/x patch is important
somehow.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
