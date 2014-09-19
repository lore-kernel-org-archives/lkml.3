Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595AbaISNeZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 09:34:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22666 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753398AbaISNeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 09:34:24 -0400
Date: Fri, 19 Sep 2014 09:33:53 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: CAI Qian <caiqian@redhat.com>
Cc: ltp-list <ltp-list@lists.sourceforge.net>,
        kexec kdump redhat mailing list 
	<kexec-kdump-list@redhat.com>,
        kexec <kexec@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        crash-utility <crash-utility@redhat.com>
Subject: Re: [RFC] autokdump - automated kdump testsuite
Message-ID: <20140919133353.GD2190@redhat.com>
References: <145412866.25258463.1411119061796.JavaMail.zimbra@redhat.com>
 <293476264.25264480.1411120345360.JavaMail.zimbra@redhat.com>
 <20140919132236.GB2190@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140919132236.GB2190@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 09:22:36AM -0400, Vivek Goyal wrote:
> On Fri, Sep 19, 2014 at 05:52:25AM -0400, CAI Qian wrote:
> > I plan to release an automated kdump testsuite that will be
> 
> So will this be a standalone test suit? Can it be merged with
> something already existing say, LTP.

Also how about calling it just kdumptest. autokdump feels more
like as if there have been improvements to kdump mechanism and
there is improved method named "autokdump".

kdumptest is more intuitive and it being "auto" is more or less
implied.

Thanks
Vivek
