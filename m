Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037Ab3FLIYQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 04:24:16 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:53376 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011Ab3FLIYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 04:24:14 -0400
MIME-Version: 1.0
In-Reply-To: <20130612073806.GG4107@intel.com>
References: <1370435206-13474-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1370435206-13474-3-git-send-email-andriy.shevchenko@linux.intel.com>
	<20130612050829.GB4107@intel.com>
	<CAHp75Ver2xo2f9crQZkAmJcTF=5cZZa3NgvufPqQW3+uTXffJA@mail.gmail.com>
	<20130612073806.GG4107@intel.com>
Date: Wed, 12 Jun 2013 13:54:13 +0530
Message-ID: <CAKohpon6hzQfkiEzfi_b7AT3KxyE88iLMGJY30etLj3VZV4cPQ@mail.gmail.com>
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

On 12 June 2013 13:08, Vinod Koul <vinod.koul@intel.com> wrote:

> Something like
> config DW_DMAC_BIG_ENDIAN_IO
>         tristate
>
> config DW_DMAC
>         select DW_DMAC_BIG_ENDIAN_IO
>
> I belive DW_DMAC is for AVR support and the PCI ones is different right.

No. DW_DMAC is for ARM as well.
