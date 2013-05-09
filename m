Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab3EIOxU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 10:53:20 -0400
Received: from eu1sys200aog122.obsmtp.com ([207.126.144.153]:59152 "EHLO
	eu1sys200aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752254Ab3EIOxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 10:53:18 -0400
Message-ID: <518BB708.7040505@st.com>
Date: Thu, 09 May 2013 15:47:36 +0100
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
Organization: STMicroelectronics
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, dong.aisheng@linaro.org,
        sameo@linux.intel.com, Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Stuart Menefy <stuart.menefy@st.com>,
        Shawn Guo <shawn.guo@linaro.org>, Olof Johansson <olof@lixom.net>,
        Jason Cooper <jason@lakedaemon.net>,
        Stephen Warren <swarren@nvidia.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Nicolas Pitre <nico@linaro.org>, Will Deacon <will.deacon@arm.com>,
        Dave Martin <dave.martin@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org
Subject: Re: [RFC 3/8] mfd:syscon: Introduce claim/read/write/release APIs
References: <1368022187-1633-1-git-send-email-srinivas.kandagatla@st.com> <1368022272-2241-1-git-send-email-srinivas.kandagatla@st.com> <201305081650.23264.arnd@arndb.de> <20130508150141.GA5057@opensource.wolfsonmicro.com> <518A8E6C.6070907@st.com> <20130509095143.GB7478@sirena.org.uk> <518B8F49.5020902@st.com> <20130509132600.GA3200@sirena.org.uk> <518BABF0.7040201@st.com> <20130509144055.GF3200@sirena.org.uk>
In-Reply-To: <20130509144055.GF3200@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/13 15:40, Mark Brown wrote:
> So what exactly is the driver doing then?  If the register maps look
> nothing like each other then what's the common functionality the driver
> is providing?
What I meant here is that, sysconf registers are reassigned per SOC, so
the sysconf register definitions change per SOC, not the register map of
the device itself.

The register map of the device itself still looks the same, however few
bits of the IP are wired up to the global sysconf registers, which is
what keeps changing, w.r.t sysconf number or bits of the sysconf itself.




