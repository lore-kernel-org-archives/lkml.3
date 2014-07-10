Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184AbaGJIoc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 04:44:32 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:42390 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbaGJIoa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 04:44:30 -0400
Date: Thu, 10 Jul 2014 10:44:21 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Fabio Coatti <fabio.coatti@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, eranian@google.com, mingo@elte.hu,
        acme@redhat.com, ak@linux.intel.com, zheng.z.yan@intel.com
Subject: Re: WARNING: CPU: 2 PID: 1 at arch/x86/mm/ioremap.c:171
 __ioremap_caller+0x290/0x2fa()
Message-ID: <20140710084421.GT3935@laptop>
References: <CADpTngUm7d88RJS9OV=64t6QrJU4r3M_Z8eV1QYWPeeB5SX5-w@mail.gmail.com>
 <1502740.TF1NxA0qsa@calvin>
 <20140709185421.GB20302@kroah.com>
 <2494065.iTji0DZuR5@calvin>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <2494065.iTji0DZuR5@calvin>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 12:48:05PM -0700, Fabio Coatti wrote:
> In data mercoledì 9 luglio 2014 11:54:21, Greg Kroah-Hartman ha scritto:
> 
> > Try cc:ing everyone on that patch, with the original information you
> > provided, and the linux-kernel mailing list.  Those developers should be
> > able to help you out properly.
> 
> Ok, here you can find the description of a problem that I'm experiencing on 
> latest kernels, since 3.15.0.  (this report comes from 3.15.4)
> 
> lug 07 22:08:00 calvin kernel: resource map sanity check conflict: 0xfed10000 
> 0xfed15fff 0xfed10000 0xfed13fff reserved
> lug 07 22:08:00 calvin kernel: ------------[ cut here ]------------

I think this is a 'known' issue on Thinkpad (iirc). For some obscure
reason its BIOS has funny ideas about resources etc.

I couldn't quickly find the prvious thread, maybe Stephane knows.
