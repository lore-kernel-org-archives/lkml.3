Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511AbaGKLFz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 07:05:55 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:61253 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbaGKLFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 07:05:54 -0400
Date: Fri, 11 Jul 2014 12:05:47 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com
Subject: Re: [STLinux Kernel] [PATCH v3 0/5] phy: miphy365x: Introduce
 support for MiPHY365x
Message-ID: <20140711110547.GA23439@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1404906074-31992-1-git-send-email-lee.jones@linaro.org>
 <53BD572C.4060406@ti.com>
 <20140710153548.GB26886@griffinp-ThinkPad-X1-Carbon-2nd>
 <20140711103104.GC30519@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140711103104.GC30519@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Fri, 11 Jul 2014, Lee Jones wrote:
> > One small point, patch 5 which adds the DT nodes may not apply as the file got
> > renamed from stih416-b2020-revE.dts to stih416-b2020e.dts.
> 
> Not required, Git should handle this seamlessly.

I didn't ask you to do anything.

Also when I made the same mistake, GIT
did not handle it seamlessly and I got the following query
from Ulf http://www.mail-archive.com/devicetree@vger.kernel.org/msg33926.html

So in case Kishon has the same problem I thought I'd do a pre-emptive strike!

regards,

Peter.
