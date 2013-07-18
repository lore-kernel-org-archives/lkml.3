Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758998Ab3GROjk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 10:39:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754673Ab3GROji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 10:39:38 -0400
Date: Thu, 18 Jul 2013 10:38:34 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Willeke <willeke@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH v7 0/5] kdump: Allow ELF header creation in new kernel
Message-ID: <20130718143834.GC785@redhat.com>
References: <OF6010D9F0.5A45F2CF-ONC1257BAB.002B1F3E-C1257BAB.002B2812@de.ibm.com>
 <20130717180049.3b9c6ec8@holzheu>
 <20130717214207.GB27633@redhat.com>
 <20130718124004.098b85f4@holzheu>
 <20130718132757.GA785@redhat.com>
 <20130718163121.0b7fdcba@holzheu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130718163121.0b7fdcba@holzheu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 04:31:21PM +0200, Michael Holzheu wrote:

[..]
> > Hi Michael,
> > 
> > Once this patch series gets merged for 3.12, can we first do some cleanup
> > of s390 code before we do further development there. Basically there is
> > no reason that s390 kdump should be any different than x86. So all the
> > logic of OLD base can go away. 
> 
> Hello Vivek,
> 
> You mean that we first integrate the agreed "ELF header in new memory"
> patch series, then do the cleanup, and after that we discuss the further
> development (storage keys)?

Yes. 

Thanks
Vivek
