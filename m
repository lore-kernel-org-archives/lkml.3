Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab3AXEjc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 23:39:32 -0500
Received: from mail-vb0-f44.google.com ([209.85.212.44]:34587 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019Ab3AXEjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 23:39:09 -0500
MIME-Version: 1.0
In-Reply-To: <1358955452-20960-3-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1358955452-20960-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1358955452-20960-3-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Thu, 24 Jan 2013 10:09:08 +0530
X-Google-Sender-Auth: PPgPru2Fp1i8TqAsVym4ipRaomc
Message-ID: <CAOh2x=n4vacpUbPYddevWU5-LUokiG4FyisYs3tA68x9yDrQog@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] dw_dmac: introduce total_len field in struct dw_desc
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 9:07 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> By this new field we distinguish a total length of the chain and the individual
> length of each descriptor in the chain.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
