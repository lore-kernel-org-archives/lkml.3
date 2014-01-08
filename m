Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989AbaAHQGS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 11:06:18 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:32794 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755750AbaAHQGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 11:06:16 -0500
Message-ID: <1389197175.23721.24.camel@hornet>
Subject: Re: [RFC 12/18] clk: versatile: Split config options for sp810 and
 vexpress_osc
From: Pawel Moll <pawel.moll@arm.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Jon Medhurst <tixy@linaro.org>, "arm@kernel.org" <arm@kernel.org>,
        Olof Johansson <olof@lixom.net>
Date: Wed, 08 Jan 2014 16:06:15 +0000
In-Reply-To: <20131223200538.25490.67340@quantum>
References: <1387815830-8794-1-git-send-email-pawel.moll@arm.com>
	 <1387815830-8794-13-git-send-email-pawel.moll@arm.com>
	 <20131223200538.25490.67340@quantum>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-23 at 20:05 +0000, Mike Turquette wrote:
> Quoting Pawel Moll (2013-12-23 08:23:44)
> > Move the Kconfig entry for Versatile (& Express) clock drivers
> > into a separate file and add individual options for sp810
> > and vexpress_osc drivers, as they are optional in some
> > configurations and may have separate dependencies.
> > 
> > Signed-off-by: Pawel Moll <pawel.moll@arm.com>
> > Cc: Mike Turquette <mturquette@linaro.org>
> 
> Is there a reason to continue to expose these as user-visible config
> options? I guess that with Device Tree we can just include clock nodes
> (or not) for boards that use these clocks (or do not use them).
>
> And it seems for many configurations COMMON_CLK_VERSATILE is always
> selected, so what is the point of the other two sub-options?

It's mostly for arm64, where all the bits and pieces are individually
selected (and SP810 is not present in some vexpress configurations).

Paweł

