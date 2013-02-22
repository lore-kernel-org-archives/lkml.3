Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759322Ab3BVSSM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 13:18:12 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:62056 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932486Ab3BVSSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 13:18:08 -0500
MIME-Version: 1.0
In-Reply-To: <1361361137-15396-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1361361137-15396-1-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Fri, 22 Feb 2013 20:18:06 +0200
Message-ID: <CAHp75Vc0xCk=nu7=_gqk9TAxD11TTRvpHjkogC5s5JjjjBgdpA@mail.gmail.com>
Subject: Re: [PATCHv2] dw_dmac: adjust slave_id accordingly to request line base
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 1:52 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> On some hardware configurations we have got the request line with the offset.
> The patch introduces convert_slave_id() helper for that cases. The request line
> base is came from the driver data provided by the platform_device_id table.
>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Viresh Kumar <viresh.kumar@linaro.org>

Vinod, is it okay to go with this version?

-- 
With Best Regards,
Andy Shevchenko
