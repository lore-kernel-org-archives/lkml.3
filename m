Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411Ab3HGIAh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 04:00:37 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:43001 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756346Ab3HGIAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 04:00:36 -0400
Date: Wed, 7 Aug 2013 09:00:30 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        linux-kernel@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        sbkim73@samsung.com, Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 1/3] clk: s2mps11: Add support for s2mps11
Message-ID: <20130807080030.GI5100@lee--X1>
References: <1373197462-4033-1-git-send-email-yadi.brar@samsung.com>
 <1373197462-4033-2-git-send-email-yadi.brar@samsung.com>
 <20130805232337.5348.79716@quantum>
 <CAKew6eXRuB5Q0f_GaCKOR7XwbX0n=-5BR_TeRVMUCD9AUHiL7w@mail.gmail.com>
 <20130806195235.5348.32684@quantum>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130806195235.5348.32684@quantum>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Aug 2013, Mike Turquette wrote:

> Quoting Yadwinder Singh Brar (2013-08-05 21:25:44)
> > Hi Mike,
> > 
> > On Tue, Aug 6, 2013 at 4:53 AM, Mike Turquette <mturquette@linaro.org> wrote:
> > > Quoting Yadwinder Singh Brar (2013-07-07 04:44:20)
> > >> This patch adds support to register three(AP/CP/BT) buffered 32.768 KHz
> > >> outputs of mfd-s2mps11 with common clock framework.
> > >>
> > >> Signed-off-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
> > >
> > > Yadwinder,
> > >
> > > Looks good to me with the exception of a binding description document.
> > > Can you provide one and squash it into this commit?
> > >
> > 
> > Binding description is provided in next patch :
> > [PATCH 2/3] mfd: sec: Add clock cell for s2mps11  :
> > https://lkml.org/lkml/2013/7/16/228
> > 
> > Since its a MFD, so i preferred to add documentation in same file
> > under mfd, same was done for regulators also.
> > If its fine with you then, I think that patch can go through MFD tree
> > as same file is touched in for-next of MFD tree.
> 
> I see. Ok I've taken patch #1 into clk-next.

Can you review the bindings in:

  mfd: sec: Add clock cell for s2mps11

... please Mike?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
