Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759AbaIEJu7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 05:50:59 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:50224 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756552AbaIEJu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 05:50:56 -0400
Message-ID: <1409910654.5546.161.camel@x220>
Subject: Re: [PATCH v2] ARM: spear: Remove references to PLAT_SPEAR_SINGLE
From: Paul Bolle <pebolle@tiscali.nl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Shiraz Hashim <shiraz.linux.kernel@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Martin Walch <walch.martin@web.de>,
        Richard Weinberger <richard@nod.at>,
        spear-devel <spear-devel@list.st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 05 Sep 2014 11:50:54 +0200
In-Reply-To: <CAOh2x=koqY0SyOuP+Xk7Zd3Ue_7HPFAxUn+V3M4ehgCv-8i02A@mail.gmail.com>
References: <1392153676.14317.8.camel@x220> <1397550407.1985.12.camel@x220>
	 <534CFB45.9070704@st.com> <1402919387.30599.4.camel@x220>
	 <1409909229.5546.146.camel@x220> <1409909940.5546.154.camel@x220>
	 <CAOh2x=koqY0SyOuP+Xk7Zd3Ue_7HPFAxUn+V3M4ehgCv-8i02A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Sep 2014 09:50:54.0826 (UTC) FILETIME=[E2B41CA0:01CFC8EE]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Viresh,

On Fri, 2014-09-05 at 15:13 +0530, Viresh Kumar wrote:
> On Fri, Sep 5, 2014 at 3:09 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> >> Ditto for v3.17-rc3 and next-20140904. Could someone please pix this up?
> 
> You need to send it to arm@kernel.org..

Will do, no problem. But why actually? (Note that MAINTAINERS is silent
on arm@kernel.org. Maybe that address is documented elsewhere.)

> > And now Rajeev's address bounces. Has Rajeev left ST?
> 
> Yeah both Shiraz/Rajeev and myself have left ST :)

I see. Is there a current address for Rajeev.? I will not keep an
Acked-by on a bouncing address.

> You can add
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

Thanks,


Paul Bolle

