Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591Ab3CBOVI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 09:21:08 -0500
Received: from mga14.intel.com ([143.182.124.37]:39060 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752446Ab3CBOVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 09:21:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,767,1355126400"; 
   d="scan'208";a="263493074"
Message-ID: <1362234094.2745.9.camel@sauron>
Subject: Re: [PATCH V3 1/3] mtd: add new fields to nand_flash_dev{}
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Huang Shijie <shijie8@gmail.com>
Cc: Huang Shijie <b32955@freescale.com>, dwmw2@infradead.org,
        computersforpeace@gmail.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Sat, 02 Mar 2013 16:21:34 +0200
In-Reply-To: <CAMiH66ExMK8rPMw3kvs9M2b-0ZSkfxBYteTi8QTZf+XCzJw5Dw@mail.gmail.com>
References: <1359349039-11510-1-git-send-email-b32955@freescale.com>
	 <1359349039-11510-2-git-send-email-b32955@freescale.com>
	 <1360684037.12703.117.camel@sauron.fi.intel.com>
	 <CAMiH66ExMK8rPMw3kvs9M2b-0ZSkfxBYteTi8QTZf+XCzJw5Dw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3 (3.6.3-2.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-02-16 at 11:56 +0800, Huang Shijie wrote:
> On Tue, Feb 12, 2013 at 11:47 PM, Artem Bityutskiy <dedekind1@gmail.com> wrote:
> > On Mon, 2013-01-28 at 12:57 +0800, Huang Shijie wrote:
> >> +       {"SmartMedia 256MiB 3,3V",      {0, 0x71}, 512, 256, 0x4000 },
> >> +       {"SmartMedia 256MiB 3,3V ROM",  {0, 0x5b}, 512, 256, 0x4000,
> >> NAND_ROM},
> >
> > Sorry for a possibly stupid question, but what does it buy you adding
> > another "0" to all the entries? I see you add another table, which you
> > look up if the "traditional" table does not work. Why you need to add
> > these zeroes?
> 
> The zeros are for the maf_id.
> 
> The dev_id is the second byte of the 8-byte id data.

It does not really make me understand why we add these zeroes, they
still look useless to me... Would you please be a little more verbose
about your solution?

-- 
Best Regards,
Artem Bityutskiy

