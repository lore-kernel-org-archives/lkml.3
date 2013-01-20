Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab3ATDvg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 22:51:36 -0500
Received: from mail-vc0-f179.google.com ([209.85.220.179]:48868 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331Ab3ATDvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 22:51:32 -0500
MIME-Version: 1.0
In-Reply-To: <1358511255-6324-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1358511255-6324-1-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Sun, 20 Jan 2013 09:21:31 +0530
X-Google-Sender-Auth: 8Z2T4AICicCS_eE-8D6ejirozSQ
Message-ID: <CAOh2x=n5_Z1oCXJH=CB7a-0b=9=ZZgqpxaMkyHsfg9LZdnpu+w@mail.gmail.com>
Subject: Re: [PATCH] dw_dmac: move soft LLP code from tasklet to dwc_scan_descriptors
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 5:44 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> The proper place for the main logic of the soft LLP mode is
> dwc_scan_descriptors. It prevents to get the transfer unexpectedly aborted in
> case the user calls dwc_tx_status.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
