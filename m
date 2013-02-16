Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395Ab3BPD0q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 22:26:46 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:50710 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316Ab3BPD0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 22:26:44 -0500
MIME-Version: 1.0
In-Reply-To: <1360952512-971558-1-git-send-email-arnd@arndb.de>
References: <1360952512-971558-1-git-send-email-arnd@arndb.de>
Date: Sat, 16 Feb 2013 08:56:43 +0530
Message-ID: <CAKohpokMi1apB17T-AUcCx6fLRkYRR2goJ8nC=E9Qc8sVYQZtA@mail.gmail.com>
Subject: Re: [PATCH 0/4] dw_dmac: introduce generic DMA binding for DT
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, Olof Johansson <olof@lixom.net>,
        linux-kernel@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 February 2013 23:51, Arnd Bergmann <arnd@arndb.de> wrote:
> As Andy pointed out today, we don't have a good solution for the
> dw_dmac DT binding in linux-next yet. I have posted my series
> once before and then got distracted after getting feedback from
> Viresh, Andy and Russell. I have now updated my earlier patch
> based on the feedback and rebased on your tree without any
> of the arm-soc patches mixed in.

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
