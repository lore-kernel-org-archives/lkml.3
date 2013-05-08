Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371Ab3EHQme (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 12:42:34 -0400
Received: from 14.mo3.mail-out.ovh.net ([188.165.43.98]:33026 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753964Ab3EHQmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 12:42:32 -0400
Date: Wed, 8 May 2013 17:40:57 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
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
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: Re: [RFC 1/8] serial:st-asc: Add ST ASC driver.
Message-ID: <20130508154057.GB3041@game.jcrosoft.org>
References: <1368022187-1633-1-git-send-email-srinivas.kandagatla@st.com>
 <1368022248-2153-1-git-send-email-srinivas.kandagatla@st.com>
 <201305081634.43498.arnd@arndb.de>
 <20130508153459.GA17186@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130508153459.GA17186@kroah.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 8290563964545379190
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeifedrieekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeifedrieekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08:34 Wed 08 May     , Greg KH wrote:
> On Wed, May 08, 2013 at 04:34:43PM +0200, Arnd Bergmann wrote:
> > > +#define ASC_MAJOR		204
> > > +#define ASC_MINOR_START		40
> > 
> > I don't know what the current policy is on allocating major/minor numbers,
> > but I'm sure you cannot just reuse one that is already used.
> 
> I agree, why are you trying to create a new tty device name?  Can't you
> use the existing ttyS name and minor number as you will not have any
> other type of serial device on this system?

Greg on ST STB for more than 10 years we use ttyASC I'll prefer ttySx

on the DTB SoC you have one one IP present the st,asc

Best Regards,
J.
> 
> thanks,
> 
> greg k-h
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss
