Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751753AbaHTIzy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 04:55:54 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:36642 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbaHTIzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 04:55:51 -0400
MIME-Version: 1.0
In-Reply-To: <1408469363-15901-2-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1408469363-15901-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1408469363-15901-2-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Wed, 20 Aug 2014 14:25:50 +0530
X-Google-Sender-Auth: Ec-7Ct_f5BM_bjSigixmk8Ox6ys
Message-ID: <CAOh2x=nxqJkN45TD1xcqgsxndLv2bJ0zSp2Cg_2rVDsdMM6bNw@mail.gmail.com>
Subject: Re: [PATCH v1 01/12] dmaengine: dw: move dw_dmac.h to where it
 belongs to
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Vinod Koul <vinod.koul@intel.com>, Mark Brown <broonie@kernel.org>,
        Hein Tibosch <hein_tibosch@yahoo.es>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Takashi Iwai <tiwai@suse.de>,
        Kweh Hock Leong <hock.leong.kweh@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>, dmaengine@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 10:59 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> There is a common storage for platform data related structures and definitions
> inside kernel source tree. The patch moves file from include/linux to
> include/linux/platform_data and renames it acoordingly. The users are also
> updated.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---

>  include/linux/dw_dmac.h                         | 111 ------------------------
>  include/linux/platform_data/dma-dw.h            | 111 ++++++++++++++++++++++++

Nice work but wrong git commands to produce this patch..
Always run format-patch with these options Atleast:

git format-patch -C -M --thread=shallow

With the -C -M option you would have got something like:

 include/linux/{dw_dmac.h => platform_data/dma-dw.h} | 0

Which would have made review so so easy :)
