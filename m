Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab3DRHNK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 03:13:10 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:41254 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906Ab3DRHNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 03:13:08 -0400
Date: Thu, 18 Apr 2013 09:13:03 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Zhouping Liu <zliu@redhat.com>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        caiqian <caiqian@redhat.com>, Caspar Zhang <czhang@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [BUG][s390x] mm: system crashed
Message-ID: <20130418071303.GB4203@osiris>
References: <156480624.266924.1365995933797.JavaMail.root@redhat.com>
 <2068164110.268217.1365996520440.JavaMail.root@redhat.com>
 <20130415055627.GB4207@osiris>
 <516B9B57.6050308@redhat.com>
 <20130416075047.GA4184@osiris>
 <1638103518.2400447.1366266465689.JavaMail.root@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1638103518.2400447.1366266465689.JavaMail.root@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041807-0342-0000-0000-000004C57B9D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 02:27:45AM -0400, Zhouping Liu wrote:
> Hello Heiko,
> > If you have some time, could you please repeat your test with the kernel
> > command line option " user_mode=home "?
> 
> I tested the system with the kernel parameter, but the issue still appeared,
> I just to say it takes longer time to reproduce the issue than the before.
> 
> > 
> > As far as I can tell there was only one s390 patch merged that was
> > mmap related: 486c0a0bc80d370471b21662bf03f04fbb37cdc6 "s390/mm: Fix crst
> > upgrade of mmap with MAP_FIXED".
> 
> also I tested the revert commit, unluckily, the same issue as the before.

Ok, thanks for verifying! I'll look into it; hopefully I can reproduce it
here as well.

Thanks!

