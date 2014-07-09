Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642AbaGIAgL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 20:36:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:36071 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752158AbaGIAfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 20:35:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,629,1400050800"; 
   d="scan'208";a="566994985"
Message-ID: <53BC8DDC.5080705@linux.intel.com>
Date: Tue, 08 Jul 2014 17:33:32 -0700
From: eric ernst <eric.ernst@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Gross <mark.gross@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH v4 1/1] pinctrl: baytrail: Warn if direct IRQ GPIO set
 to output
References: <CACRpkdbU-d7Gdji2fJr4h7bC58d63E_CAVeSHZm3ARuut1UFKQ@mail.gmail.com>	<1402596380-18783-1-git-send-email-eric.ernst@linux.intel.com> <CACRpkdbBsP-_K4Y2MS17EuzZeho6uYKqRPHPPL0-KDAamsdxvQ@mail.gmail.com>
In-Reply-To: <CACRpkdbBsP-_K4Y2MS17EuzZeho6uYKqRPHPPL0-KDAamsdxvQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mea culpa - thanks Linus.  I saw a note from kbuild test
robot indicating an issue, but given your response, I am
assuming it was from your first build attempt.  Thanks.

On 14-07-07 02:14 PM, Linus Walleij wrote:
> On Thu, Jun 12, 2014 at 8:06 PM,  <eric.ernst@linux.intel.com> wrote:
>
>> +       WARN(readl(conf_reg) & BYT_DIRECT_IRQ_EN,
>> +               "Potential Error: Setting GPIO with direct_irq_en to output");
> Hm in the v4 version you somehow managed to drop the definition
> of BYT_DIRECT_IRQ_EN...
>
> I patched it back in. Let's hope it compiles now.
>
> Yours,
> Linus Walleij

