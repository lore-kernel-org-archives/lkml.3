Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbaIWMKc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 08:10:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31361 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636AbaIWMKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 08:10:31 -0400
Date: Tue, 23 Sep 2014 08:09:59 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: CAI Qian <caiqian@redhat.com>
Cc: ltp-list <ltp-list@lists.sourceforge.net>,
        kexec <kexec@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        crash-utility <crash-utility@redhat.com>
Subject: Re: [RFC] autokdump - automated kdump testsuite
Message-ID: <20140923120959.GB1732@redhat.com>
References: <145412866.25258463.1411119061796.JavaMail.zimbra@redhat.com>
 <293476264.25264480.1411120345360.JavaMail.zimbra@redhat.com>
 <20140919132236.GB2190@redhat.com>
 <594480021.25988504.1411355660836.JavaMail.zimbra@redhat.com>
 <20140922144713.GA4250@redhat.com>
 <1446076274.27552759.1411440835273.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1446076274.27552759.1411440835273.JavaMail.zimbra@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 10:53:55PM -0400, CAI Qian wrote:

[..]
> > Why not simply let the respective service on the host do this job and
> > test only makes sure that kdump service is running. It feels little
> > out of place that a test is generating custom initramfs.
> Because not every distro will have a kdump service like Fedora.

So which distro does not have a service? Do we know this or we are
assuming that distributions don't have a service to load/unload
kdump kernel.

[..]
> > makedumpfile will reduce the vmcore file size to few hundreds of mega
> > bytes on most of the systems. Especially, this is just a test, so
> > system will be lightly loaded and vmcore will be small after filtering.
> It probably actually have test cases to heavily loaded the memory before
> dumping.

Your original proposal does not take care of this case either. A test
case could be heavily used memory and if user does not have sufficient
memory to save core, so be it. That test will fail.

Thanks
Vivek
