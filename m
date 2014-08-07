Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425AbaHGWqX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 18:46:23 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:43719 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaHGWqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 18:46:22 -0400
Date: Thu, 7 Aug 2014 15:46:18 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Nick Krause <xerofoify@gmail.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Su Tao <tao.su@intel.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        LKP <lkp@01.org>, Jet Chen <jet.chen@intel.com>
Subject: Re: [sbc_gxx] kernel BUG at include/linux/mtd/map.h:148!
Message-ID: <20140807224618.GQ3711@ld-irv-0074>
References: <20140805135947.GA5593@localhost>
 <CAPDOMVgN=tc_o7E19ss4j5FAG4vpgUSzuUXYLSNGfpWCvPsAwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDOMVgN=tc_o7E19ss4j5FAG4vpgUSzuUXYLSNGfpWCvPsAwA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Aug 05, 2014 at 08:08:57PM -0400, Nick Krause wrote:
> On Tue, Aug 5, 2014 at 9:59 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> > Hello,
> >
> > This is an old BUG that still lives in linux-next.
> >
> > [    4.284620] device id = 2670
> > [    4.286157] SBC-GXx flash: IO:0x258-0x259 MEM:0xdc000-0xdffff
> > [    4.287060] ------------[ cut here ]------------
> > [    4.287722] kernel BUG at include/linux/mtd/map.h:148!
> > [    4.288048] invalid opcode: 0000 [#1] PREEMPT SMP
>
> I am new , here and will try to trace your issue on linus's tree
> unless there is a major difference between Linus's tree and
> linux-next.
> If there is please let me known before I start tracing this.

This is a known issue, and Fengguang has reported this before:

  http://lists.infradead.org/pipermail/linux-mtd/2014-March/053019.html

I'm still not quite sure how to solve this one. It seems to be a
limitation of the kconfig language.

Brian
