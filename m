Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519AbaHHKQs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 06:16:48 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:48627 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756336AbaHHKQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 06:16:45 -0400
Date: Fri, 8 Aug 2014 11:16:41 +0100
From: Leif Lindholm <leif.lindholm@linaro.org>
To: Rob Herring <robh@kernel.org>
Cc: Kees Cook <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liu hua <sdu.liu@huawei.com>, Mark Salter <msalter@redhat.com>,
        Rabin Vincent <rabin@rab.in>,
        Nikolay Borisov <Nikolay.Borisov@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>, Doug Anderson <dianders@google.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Will Deacon <will.deacon@arm.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3/8] arm: mm: reduce fixmap kmap from 32 to 16 CPUS
Message-ID: <20140808101640.GO4179@bivouac.eciton.net>
References: <1407423713-4160-1-git-send-email-keescook@chromium.org>
 <1407423713-4160-4-git-send-email-keescook@chromium.org>
 <CAL_JsqJZbbH=PwDzLKSwKiW1Y=N8MLgwEkp=xQaD_ST_uB-_Rw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_JsqJZbbH=PwDzLKSwKiW1Y=N8MLgwEkp=xQaD_ST_uB-_Rw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2014 at 05:18:44PM -0500, Rob Herring wrote:
> On Thu, Aug 7, 2014 at 10:01 AM, Kees Cook <keescook@chromium.org> wrote:
> > More room is needed in the fixmap range for non-kmap fixmap entries. This
> > reduces the kmap range from 32 to 16 CPUs.
> 
> Do you want this merged or just doing this to get the rest of your
> series working? I'll post my patch for making the fixmap region 3MB
> (it adds back the first 1MB of the top pmd).

Well, I would quite like the generic fixmap stuff merged as soon as
possible, so that early_ioremap can go in. That way, the UEFI patches
are unblocked, and we can start booting the D01 in a sane way rather
than the broken-by-design built-in Linux loader.
 
/
    Leif
