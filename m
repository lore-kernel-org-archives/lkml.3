Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab3DLF75 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 01:59:57 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:46941 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875Ab3DLF7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 01:59:55 -0400
Date: Fri, 12 Apr 2013 08:59:32 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kbuild@01.org,
        Linaro MM SIG <linaro-mm-sig@lists.linaro.org>,
        kernel-janitors@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/2 -next] dma-buf: double unlock in debugfs code
Message-ID: <20130412055931.GI6692@mwanda>
References: <20130411062339.GA7603@elgon.mountain>
 <CAO_48GHvAUmVmmZyHiEXzN3nWtTjC9iz-hEo-z3GrR2T-LZ-0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO_48GHvAUmVmmZyHiEXzN3nWtTjC9iz-hEo-z3GrR2T-LZ-0w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 12, 2013 at 08:43:05AM +0530, Sumit Semwal wrote:
> Hi Dan,
> 
> On Apr 11, 2013 11:54 AM, "Dan Carpenter" <dan.carpenter@oracle.com> wrote:
> >
> > We unlock here when we failed to take the lock.
> Thanks for catching this; I will add it to the for-next queue.
> 
> Could I merge this change with the main patch while submitting to mainline?
> With an attribution to you, of course.

Yeah.  Just merge it.  Don't stress about attribution.

regards,
dan carpenter

