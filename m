Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008Ab3BTXf7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 18:35:59 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47296 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab3BTXf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 18:35:58 -0500
Date: Wed, 20 Feb 2013 23:35:32 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alessandro Rubini <rubini@gnudd.com>, linux-kernel@vger.kernel.org,
        giancarlo.asnaghi@st.com, ciminaghi@gnudd.com, alan@linux.intel.com,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org
Subject: Re: [PATCH V5 4/5] drivers/amba: add support for a PCI bridge
Message-ID: <20130220233532.GY17833@n2100.arm.linux.org.uk>
References: <51254F57.7060603@zytor.com> <cover.1361393832.git.rubini@gnudd.com> <52b9f4e1cc04b7c656e10ee16020090601f6f537.1361393832.git.rubini@gnudd.com> <20130220222419.GX17833@n2100.arm.linux.org.uk> <20130220224528.GA24819@mail.gnudd.com> <51255329.4070506@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51255329.4070506@zytor.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 02:50:17PM -0800, H. Peter Anvin wrote:
> On 02/20/2013 02:45 PM, Alessandro Rubini wrote:
> > [meanwhile I posted V6 with the acked-by of linusw and others, that
> > were missing in V5]
> > 
> > rmk:
> >>> I'm happy to take it through my tree if everyone is now happy with this.
> > 
> > hpa: 
> >> I am okay with that, although I would like to make sure we do a bunch of
> >> x86 randconfigs on it before pushing it to Linus.
> > 
> > I did like this:
> >   - disable STA2X11 (and thus AMBA) and build
> >   - enable STA2X11, answer y to all new questions and build
> > 
> > So there's nothing left (you'll have two unrelated warnings, that I'm
> > working on and I'll post a fix tomorrow).  Sure, Peter, first time I
> > didn't do that test and missed some of the drivers.
> > 
> 
> I was just concerned that rmk wouldn't necessarily do those tests as a
> matter of process.
> 
> So Russell -- how do you want to handle this?  Should I take them (and
> ask Ingo to put them through his test machinery) or do you want to (and
> run x86 randconfigs as part of your testing)?

Well, I'm happy to take the non-x86 bits if that's what others want (for
the _next_ merge window, not this one.)  That _should_ result in x86 not
seeing this stuff until it gets the ARM_AMBA definition enabled, and
giving it a full cycle of testing.

However, if we want to keep the patch set together and route it via
another tree, I'm also fine with that too.
