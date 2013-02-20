Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab3BTWpx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 17:45:53 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:33987 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071Ab3BTWpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 17:45:52 -0500
Date: Wed, 20 Feb 2013 23:45:28 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: hpa@zytor.com
Cc: linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        giancarlo.asnaghi@st.com, ciminaghi@gnudd.com, alan@linux.intel.com,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org
Subject: Re: [PATCH V5 4/5] drivers/amba: add support for a PCI bridge
Message-ID: <20130220224528.GA24819@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <51254F57.7060603@zytor.com>
References: <51254F57.7060603@zytor.com>
  <cover.1361393832.git.rubini@gnudd.com>
 <52b9f4e1cc04b7c656e10ee16020090601f6f537.1361393832.git.rubini@gnudd.com>
 <20130220222419.GX17833@n2100.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[meanwhile I posted V6 with the acked-by of linusw and others, that
were missing in V5]

rmk:
>> I'm happy to take it through my tree if everyone is now happy with this.

hpa: 
> I am okay with that, although I would like to make sure we do a bunch of
> x86 randconfigs on it before pushing it to Linus.

I did like this:
  - disable STA2X11 (and thus AMBA) and build
  - enable STA2X11, answer y to all new questions and build

So there's nothing left (you'll have two unrelated warnings, that I'm
working on and I'll post a fix tomorrow).  Sure, Peter, first time I
didn't do that test and missed some of the drivers.

Thanks
/alessandro
