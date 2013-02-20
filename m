Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935566Ab3BTNgo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 08:36:44 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:50160 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935246Ab3BTNgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 08:36:43 -0500
MIME-Version: 1.0
In-Reply-To: <1361361137-15396-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1361361137-15396-1-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Wed, 20 Feb 2013 19:06:41 +0530
Message-ID: <CAKohpokeCE920Rv3u6nDoUOf2kitUBaM+4jOCzSoE1R4BbJftQ@mail.gmail.com>
Subject: Re: [PATCHv2] dw_dmac: adjust slave_id accordingly to request line base
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 February 2013 17:22, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> On some hardware configurations we have got the request line with the offset.
> The patch introduces convert_slave_id() helper for that cases. The request line
> base is came from the driver data provided by the platform_device_id table.
>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Viresh Kumar <viresh.kumar@linaro.org>

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
