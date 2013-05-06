Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab3EFKC1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 06:02:27 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:43279 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753017Ab3EFKCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 06:02:25 -0400
Date: Mon, 6 May 2013 11:54:30 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: mingo@kernel.org
Cc: bp@alien8.de, hpa@zytor.com, ciminaghi@gnudd.com,
        jaswinder.singh@linaro.org, will.deacon@arm.com,
        linux@arm.linux.org.uk, tglx@linutronix.de, mingo@redhat.com,
        djbw@fb.com, vinod.koul@intel.com, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, wim@iguana.be, cjb@laptop.org,
        davidb@codeaurora.org, nico@fluxnic.net, ben-linux@fluff.org,
        viresh.linux@gmail.com, rajeev-dlh.kumar@st.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        giancarlo.asnaghi@st.com
Subject: Re: [PATCH v4 0/7] enable support for AMBA drivers under x86
Message-ID: <20130506095430.GA26898@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <20130506094154.GA9464@gmail.com>
References: <20130506094154.GA9464@gmail.com>
  <20130505123633.GA14095@pd.tnic>  <50C93A83.8040106@zytor.com>
  <1355146956-6009-1-git-send-email-ciminaghi@gnudd.com>
  <50C93718.2090706@zytor.com>  <20121213181449.GA15966@mail.gnudd.com>
  <20130505202422.GA13758@mail.gnudd.com>  <20130505203932.GA12742@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All-To: mingo@kernel.org,bp@alien8.de,hpa@zytor.com,ciminaghi@gnudd.com,jaswinder.singh@linaro.org,will.deacon@arm.com,linux@arm.linux.org.uk,tglx@linutronix.de,mingo@redhat.com,djbw@fb.com,vinod.koul@intel.com,grant.likely@secretlab.ca,linus.walleij@linaro.org,wim@iguana.be,cjb@laptop.org,davidb@codeaurora.org,nico@fluxnic.net,ben-linux@fluff.org,viresh.linux@gmail.com,rajeev-dlh.kumar@st.com,linux-kernel@vger.kernel.org,linux-arm-kernel@lists.infradead.org,giancarlo.asnaghi@st.com Re: [PATCH v4 0/7] enable support for AMBA drivers under x86
> From: Ingo Molnar <mingo@kernel.org>
> To: Borislav Petkov <bp@alien8.de>
> Cc: Alessandro Rubini <rubini@gnudd.com>, hpa@zytor.com, ciminaghi@gnudd.com,         jaswinder.singh@linaro.org, will.deacon@arm.com,         linux@arm.linux.org.uk, tglx@linutronix.de, mingo@redhat.com,         djbw@fb.com, vinod.koul@intel.com, grant.likely@secretlab.ca,         linus.walleij@linaro.org, wim@iguana.be, cjb@laptop.org,         davidb@codeaurora.org, nico@fluxnic.net, ben-linux@fluff.org,         viresh.linux@gmail.com, rajeev-dlh.kumar@st.com,         linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,         giancarlo.asnaghi@st.com
> Subject: Re: [PATCH v4 0/7] enable support for AMBA drivers under x86
> Date: Mon, 6 May 2013 11:41:54 +0200

> A lot happened meanwhile - patches got acked, applied - so I expected a 
> resend of the patches that are still pending, with all acks in place in 
> the patches (not in the cover letter), and against Linus's latest tree.

Ok, I'll resend this AMBA/PCI set.  But this warning we are discussing
about is unrelated and I sent it by itself in february.  Anyways, I'll
add it to the patch-set I'm going to send most likely tomorrow.

thanks
/alessndro
