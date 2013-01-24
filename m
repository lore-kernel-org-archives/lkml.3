Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab3AXKu2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 05:50:28 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:39618 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381Ab3AXKuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 05:50:24 -0500
MIME-Version: 1.0
In-Reply-To: <1359023660-29084-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1359023660-29084-1-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Thu, 24 Jan 2013 16:20:23 +0530
X-Google-Sender-Auth: al30CcP-zaJAAngWO0LS5abPR5c
Message-ID: <CAOh2x=mgqjR=Rtq=wVqM6Ut=LfdaskoMdo3K6qBbCSHV4qt0tw@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] dw_dmac: return actual residue value
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 4:04 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> Since v2:
>  - get rid of dwc_update_residue(): for soft LLP mode we assign residue in
>    dwc_do_start() and decrease it at each interrupt.

I was talking about this comment or design we thought of. Where is this done.
I see residue being updated only from scan_descriptors().
