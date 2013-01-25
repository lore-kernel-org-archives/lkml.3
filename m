Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677Ab3AYJzz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 04:55:55 -0500
Received: from mail-vb0-f41.google.com ([209.85.212.41]:65146 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944Ab3AYJzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 04:55:53 -0500
MIME-Version: 1.0
In-Reply-To: <1359107283-5274-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1359107283-5274-1-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Fri, 25 Jan 2013 15:25:52 +0530
X-Google-Sender-Auth: joFKO-H3bdJ5fiA7WDBQjkEwhqs
Message-ID: <CAOh2x=nwB-KRG=OaB1ZM5DQvJYU9rnm2da3DCUn1DR0AfF+EvA@mail.gmail.com>
Subject: Re: [PATCH v4 0/4] dw_dmac: return actual residue value
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 3:17 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> The patch series is targeted for getting proper residue value.
>
> Since v3:
> - split dwc_get_residue() from dwc_tx_status and improve locking there
> - patch 1/4 "dw_dmac: remove unnecessary tx_list field in dw_dma_chan" was
>   amended a bit to simplify patch 4/4

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
