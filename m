Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab3AWKYp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 05:24:45 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:56553 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509Ab3AWKYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 05:24:43 -0500
MIME-Version: 1.0
In-Reply-To: <CAHp75VdBB1mk0PaG1z9JR0PmQPS5gtgnXSs7_SoBY7TLNp9ZtQ@mail.gmail.com>
References: <1358758844-24711-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1358758844-24711-2-git-send-email-andriy.shevchenko@linux.intel.com>
	<CAOh2x==FoW5Sh5KFt9iO+_04dEbwsQHJX3rsTWNqFiZqTbPn6A@mail.gmail.com>
	<1358846546.12502.57.camel@smile>
	<CAKohpo=m-s4+q+4v2v+8nzC32FRzJAb58no2hZLV_5QqTj4wig@mail.gmail.com>
	<1358932355.12502.68.camel@smile>
	<CAKohpo=BHGukSQJJGUS=H++qzxME3aEEQZR8QiyHPU8LabHsSw@mail.gmail.com>
	<CAHp75VeNe1Z9CqYXVjV6am_vg=5XF=vx1i47h71xRdTvT6hSGA@mail.gmail.com>
	<CAKohpo=_BR49Og4MRPB9SfDEwnD3OoKwFWiCsTKNfpYFSyp25Q@mail.gmail.com>
	<CAHp75VdBB1mk0PaG1z9JR0PmQPS5gtgnXSs7_SoBY7TLNp9ZtQ@mail.gmail.com>
Date: Wed, 23 Jan 2013 15:54:43 +0530
Message-ID: <CAKohpokH_8-u3tt-Zv=Zxe+wcESQfecCFCEPFGrVMWCLDr5OAQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] dw_dmac: return proper residue value
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 January 2013 15:50, Andy Shevchenko <andy.shevchenko@gmail.com> wrote:
> What about to calc len every time from lli.* instead of keeping it in
> the len field of the descriptor?

That's even bad.. we spend time on something for no good reason. :)
I would still suggest you to add len and total_len in descriptor :)
