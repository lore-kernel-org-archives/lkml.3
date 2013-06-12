Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264Ab3FLJGi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 05:06:38 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:37128 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756014Ab3FLJGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 05:06:33 -0400
MIME-Version: 1.0
In-Reply-To: <20130612081917.GL4107@intel.com>
References: <1370435206-13474-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1370435206-13474-3-git-send-email-andriy.shevchenko@linux.intel.com>
	<20130612050829.GB4107@intel.com>
	<CAHp75Ver2xo2f9crQZkAmJcTF=5cZZa3NgvufPqQW3+uTXffJA@mail.gmail.com>
	<20130612073806.GG4107@intel.com>
	<CAHp75VfsSDdLa_uPULbhVGproxnD5mofYm62O75y4xRbPBJ7pQ@mail.gmail.com>
	<20130612075225.GI4107@intel.com>
	<CAHp75Vc=hO_FF0WMvhPm6MMRuCb+=MhOEOCSYb_TaCRf-xQ=sg@mail.gmail.com>
	<20130612081202.GK4107@intel.com>
	<CAKohpok8jyUF33hatMJzLwokHM2Ou=N8rHQ4oQ5xQ2AiSSN__w@mail.gmail.com>
	<20130612081917.GL4107@intel.com>
Date: Wed, 12 Jun 2013 14:36:32 +0530
Message-ID: <CAKohponcvCCYdZ3iiMmWgU_Q2FCVxjqy8M6dO8zOfwnG51E7jQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] dma: move dw_dmac driver to an own directory
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        spear-devel <spear-devel@list.st.com>, Arnd Bergmann <arnd@arndb.de>,
        Felipe Balbi <balbi@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 June 2013 13:49, Vinod Koul <vinod.koul@intel.com> wrote:
> Well now the config option is not selected by users, so they dont need to know.
> It was useful in knowing what to select earlier

I am concerned about driver writers rather than end users as this is
fixed for a driver. And yes its better we don't give a choice to users
to deselect it.

> For documenting, we can add this in commit log or better in driver code where
> you use this

Commit log wouldn't be sufficient now. Please add it somewhere in code.
