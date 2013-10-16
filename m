Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab3JPGrG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 02:47:06 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:53328 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960Ab3JPGrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 02:47:04 -0400
Date: Wed, 16 Oct 2013 08:46:59 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Roel Kluin <roel.kluin@gmail.com>, Andrew Jones <drjones@redhat.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] jump_label: unlikely(x) > 0
Message-ID: <20131016064659.GA22509@gmail.com>
References: <alpine.DEB.2.02.1310112241220.11060@Z>
 <20131011135704.6fd455e2387a37f1972a4e0f@linux-foundation.org>
 <525D7315.8080005@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <525D7315.8080005@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@linux.intel.com> wrote:

> On 10/11/2013 01:57 PM, Andrew Morton wrote:
> > 
> > I'm sure this was intended instead ;) The patch doesn't seem to make
> > any difference in code generation with my gcc.
> > 
> 
> Which is odd, because doesn't unlikely() booleanize?

It's supposed to:

 include/linux/compiler.h:#define unlikely_notrace(x)    __builtin_expect(!!(x), 0)

Thanks,

	Ingo
