Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089AbaIESbf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 14:31:35 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:50342 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbaIESbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 14:31:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stern@rowland.harvard.edu, gregkh@linuxfoundation.org,
        srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com, lee.jones@linaro.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH RESEND v5 1/5] usb: host: ehci-st: Add EHCI support for ST STB devices
Date: Fri, 05 Sep 2014 20:30:49 +0200
Message-ID: <3890179.kgPZYmEVZm@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140905181636.GA1715@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1409937829-23708-1-git-send-email-peter.griffin@linaro.org> <202755915.brE74x99uQ@wuerfel> <20140905181636.GA1715@griffinp-ThinkPad-X1-Carbon-2nd>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:zjjGNdiHamvYIFgSIuFtQ/jtAwyC1D681+r/DjAGTmU
 iEZVVZgq3jECb5vL6JH8xOtgrexUC99LxVS3jw3YrkxCpV5Q3o
 8vHIwmyD5RwlW2gszi9hQbfRbTOiYQFGaMob1IIuBA930tFuQr
 gVJpqfIdbPsOO3fPXfckD2EZV33xDu6Y/OW+0j0QETM1yEAL2r
 V83OYUaPCSLIj9i062P4Qa0NF4s0xF6JNjFya0yIyp0YNW12gh
 +OUb78BJQ1jnTCIjeXTQETvdsxZ0yKKmUdnk4la1aNjks2oiue
 LEmrmExd2Vv/+M+Jq/0Lil3tgaNDv+ZKe/pcdOIz8VvM+VBThS
 fzOtk5coMuLKdAOA9DS8=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 September 2014 19:16:36 Peter Griffin wrote:
> On Fri, 05 Sep 2014, Arnd Bergmann wrote:
> 
> > On Friday 05 September 2014 18:23:45 Peter Griffin wrote:
> > > +struct st_platform_priv {
> > > +       struct clk *clks[USB_MAX_CLKS];
> > > +       struct clk *clk48;
> > > +       struct reset_control *rst;
> > > +       struct reset_control *pwr;
> > > +       struct phy *phy;
> > > +};
> > 
> > Any reason why this is in a shared header file? It looks like
> > duplicating the structure under two different names would
> > actually be shorter and keep the drivers more readable as they'd
> > be self-contained, even when they have the exact same structure.
> 
> The only reason was it was a identical structure so I put it in a shared
> header file. I can unabstract it if you want?

Yes, I think that would be an improvement. Everything looks great to me
otherwise, at least after a brief look.

	Arnd
