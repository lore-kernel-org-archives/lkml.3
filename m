Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932352AbaIEMlf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 08:41:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:63855 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932083AbaIEMld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 08:41:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,472,1406617200"; 
   d="scan'208";a="586757351"
Message-ID: <1409920745.30155.93.camel@linux.intel.com>
Subject: Re: [PATCH v4 01/12] hexdump: introduce test suite
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Helge Deller <deller@gmx.de>,
        Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>, Marek Vasut <marex@denx.de>,
        Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
        Benjamin Romer <benjamin.romer@unisys.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Chen Gang <gang.chen.5i5j@gmail.com>
Date: Fri, 05 Sep 2014 15:39:05 +0300
In-Reply-To: <CAMuHMdXQ953Cx-MNSvWCKbQhezxr31bpAHo4JMJBK6dCoOQwnw@mail.gmail.com>
References: <1409840819-18976-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1409840819-18976-2-git-send-email-andriy.shevchenko@linux.intel.com>
	 <CAMuHMdXQ953Cx-MNSvWCKbQhezxr31bpAHo4JMJBK6dCoOQwnw@mail.gmail.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.5-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-09-05 at 11:37 +0200, Geert Uytterhoeven wrote:
> On Thu, Sep 4, 2014 at 4:26 PM, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> > Test different scenarios of function calls located in lib/hexdump.c.
> >
> > Currently hex_dump_to_buffer() is only tested and test data is provided for
> > little endian CPUs.
> 
> That's a nice one to be amended using Chen's
> "arch: Kconfig: Let all little endian architectures define
> CPU_LITTLE_ENDIAN explicitly".

I don't see it in the upstream yet, right? Thus, I wouldn't like to
depend on it now.


-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy

