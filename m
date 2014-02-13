Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697AbaBMNLs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 08:11:48 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:27482 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754498AbaBMNLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 08:11:47 -0500
Message-ID: <1392297105.848.82.camel@hornet>
Subject: Re: [PATCH 06/12] mfd: vexpress-sysreg: Add labels to gpio banks
From: Pawel Moll <pawel.moll@arm.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "arm@kernel.org" <arm@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Date: Thu, 13 Feb 2014 13:11:45 +0000
In-Reply-To: <CACRpkdZjrCdhyBMF2WbDCnHuuMSpcpwiPx2k555PY3yBwdc1aw@mail.gmail.com>
References: <1392138636-29240-1-git-send-email-pawel.moll@arm.com>
	 <1392138636-29240-7-git-send-email-pawel.moll@arm.com>
	 <CACRpkdZjrCdhyBMF2WbDCnHuuMSpcpwiPx2k555PY3yBwdc1aw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-02-13 at 13:08 +0000, Linus Walleij wrote:
> On Tue, Feb 11, 2014 at 6:10 PM, Pawel Moll <pawel.moll@arm.com> wrote:
> 
> > ... so debugfs interfaces are easier to use.
> >
> > Cc: Linus Walleij <linus.walleij@linaro.org>
> > Cc: Alexandre Courbot <gnurou@gmail.com>
> > Cc: Samuel Ortiz <sameo@linux.intel.com>
> > Cc: Lee Jones <lee.jones@linaro.org>
> > Signed-off-by: Pawel Moll <pawel.moll@arm.com>
> 
> This doesn't apply to the v3.14-rc1-based GPIO tree. Can you rebase it
> with Lee's ACK so I can apply this?

Uh, it won't apply. This series depends on the one reworking sysregs.
I'll send them separately once it's ready. Sorry about confusion and
thanks for trying!

Pawel

