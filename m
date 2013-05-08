Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189Ab3EHPxF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 11:53:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35933 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757070Ab3EHPxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 11:53:02 -0400
Date: Wed, 8 May 2013 08:53:01 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Will Deacon <will.deacon@arm.com>, jslaby@suse.cz,
        Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, Nicolas Pitre <nico@linaro.org>,
        linux-doc@vger.kernel.org,
        Stephen Gallimore <stephen.gallimore@st.com>,
        linux-serial@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Stephen Warren <swarren@nvidia.com>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/8] serial:st-asc: Add ST ASC driver.
Message-ID: <20130508155301.GB27273@kroah.com>
References: <1368022187-1633-1-git-send-email-srinivas.kandagatla@st.com>
 <1368022248-2153-1-git-send-email-srinivas.kandagatla@st.com>
 <201305081634.43498.arnd@arndb.de>
 <20130508153459.GA17186@kroah.com>
 <20130508154057.GB3041@game.jcrosoft.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130508154057.GB3041@game.jcrosoft.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 08, 2013 at 05:40:57PM +0200, Jean-Christophe PLAGNIOL-VILLARD wrote:
> On 08:34 Wed 08 May     , Greg KH wrote:
> > On Wed, May 08, 2013 at 04:34:43PM +0200, Arnd Bergmann wrote:
> > > > +#define ASC_MAJOR		204
> > > > +#define ASC_MINOR_START		40
> > > 
> > > I don't know what the current policy is on allocating major/minor numbers,
> > > but I'm sure you cannot just reuse one that is already used.
> > 
> > I agree, why are you trying to create a new tty device name?  Can't you
> > use the existing ttyS name and minor number as you will not have any
> > other type of serial device on this system?
> 
> Greg on ST STB for more than 10 years we use ttyASC I'll prefer ttySx

For 10+ years you have had an out-of-tree serial driver?  What
major/minor numbers did you use for it?

> on the DTB SoC you have one one IP present the st,asc

I don't understand, what do you mean by this?

confused,

greg k-h
