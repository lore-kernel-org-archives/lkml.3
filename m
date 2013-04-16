Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086Ab3DPIDy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 04:03:54 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:45514 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773Ab3DPIDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 04:03:48 -0400
Date: Tue, 16 Apr 2013 10:03:40 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Simon Jeons <simon.jeons@gmail.com>
Cc: Zhouping Liu <zliu@redhat.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, caiqian <caiqian@redhat.com>,
        Caspar Zhang <czhang@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [BUG][s390x] mm: system crashed
Message-ID: <20130416080340.GA23856@osiris>
References: <156480624.266924.1365995933797.JavaMail.root@redhat.com>
 <2068164110.268217.1365996520440.JavaMail.root@redhat.com>
 <20130415055627.GB4207@osiris>
 <516B9B57.6050308@redhat.com>
 <20130416075047.GA4184@osiris>
 <516D044B.3040300@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <516D044B.3040300@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041608-0342-0000-0000-000004C02EA4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 03:56:59PM +0800, Simon Jeons wrote:
> Hi Heiko,
> >If you have some time, could you please repeat your test with the kernel
> >command line option " user_mode=home "?
> 
> What's the meaning of this command line? I can't find it in
> Documentation/kernel-parameters.txt/

It switches the architectural address space where kernel and user space
reside in.
We only recently switched the default address space for user space from
home space to primary space, since that's needed for kvm.
The user space runs in home space mode will be removed in the future; we
keep it currently as fallback, just in case something breaks.

