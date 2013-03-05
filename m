Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932883Ab3CEA3D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 19:29:03 -0500
Received: from ozlabs.org ([203.10.76.45]:55366 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758341Ab3CEA3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 19:29:01 -0500
Date: Tue, 5 Mar 2013 11:28:57 +1100
From: Michael Ellerman <michael@ellerman.id.au>
To: Mike Qiu <qiudayu@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Enable multiple MSI feature in pSeries
Message-ID: <20130305002857.GA7656@concordia>
References: <1358235536-32741-1-git-send-email-qiudayu@linux.vnet.ibm.com>
 <1362107325.2712.2.camel@localhost>
 <20130301035417.GA17236@concordia>
 <513411AD.5010408@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <513411AD.5010408@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 04, 2013 at 11:14:53AM +0800, Mike Qiu wrote:
> 于 2013/3/1 11:54, Michael Ellerman 写道:
> >On Fri, Mar 01, 2013 at 11:08:45AM +0800, Mike wrote:
> >>Hi all
> >>
> >>Any comments? or any questions about my patchset?
> >You were going to get some performance numbers that show a definite
> >benefit for using more than one MSI.

> Yes, but my patch just enable the kernel to support this feature, whether
> to use it depens on the device driver.

Sure, but we don't add code just for fun, so unless there's a good
reason to add the feature - like better performance - we won't bother.

> And this feature has been merged to the kernel for X86 for a long time.
> See commit: 5ca72c4f7c412c2002363218901eba5516c476b1
> 51906e779f2b13b38f8153774c4c7163d412ffd9

That commit was merged in 3.9-rc1, ie. a few days ago, so no it has not been
in x86 for a long time.

That code removes the need for your first patch, which is a good start.
Please send a new version using irq_set_msi_desc_off().

cheers
