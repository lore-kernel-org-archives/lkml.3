Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab3AWKeL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 05:34:11 -0500
Received: from mga09.intel.com ([134.134.136.24]:5794 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754788Ab3AWKeJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 05:34:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,520,1355126400"; 
   d="scan'208";a="251103962"
Message-ID: <1358937235.12502.70.camel@smile>
Subject: Re: [PATCH 2/2] dw_dmac: return proper residue value
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Date: Wed, 23 Jan 2013 12:33:55 +0200
In-Reply-To: <CAKohpokH_8-u3tt-Zv=Zxe+wcESQfecCFCEPFGrVMWCLDr5OAQ@mail.gmail.com>
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
	 <CAKohpokH_8-u3tt-Zv=Zxe+wcESQfecCFCEPFGrVMWCLDr5OAQ@mail.gmail.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-23 at 15:54 +0530, Viresh Kumar wrote: 
> On 23 January 2013 15:50, Andy Shevchenko <andy.shevchenko@gmail.com> wrote:
> > What about to calc len every time from lli.* instead of keeping it in
> > the len field of the descriptor?
> 
> That's even bad.. we spend time on something for no good reason. :)
> I would still suggest you to add len and total_len in descriptor :)

Okay, let's stick to this one for now.
I will come with patch v2 soon.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
