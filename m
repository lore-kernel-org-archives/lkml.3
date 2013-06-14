Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070Ab3FNHQr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 03:16:47 -0400
Received: from eu1sys200aog122.obsmtp.com ([207.126.144.153]:35705 "EHLO
	eu1sys200aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751868Ab3FNHQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 03:16:45 -0400
Message-ID: <51BAC263.1000908@st.com>
Date: Fri, 14 Jun 2013 08:12:35 +0100
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
Organization: STMicroelectronics
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, linux@arm.linux.org.uk,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Olof Johansson <olof@lixom.net>, Rob Herring <rob.herring@calxeda.com>,
        Rob Landley <rob@landley.net>, Samuel Ortiz <sameo@linux.intel.com>,
        Stephen Gallimore <stephen.gallimore@st.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Prisk <linux@prisktech.co.nz>
Subject: Re: [PATCH v2 07/11] ARM:stixxxx: Add STiH416 SOC support
References: <1370855828-5318-1-git-send-email-srinivas.kandagatla@st.com> <1370856425-7135-1-git-send-email-srinivas.kandagatla@st.com> <3733079.FxbR14kFrs@wuerfel>
In-Reply-To: <3733079.FxbR14kFrs@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/13 14:52, Arnd Bergmann wrote:
> On Monday 10 June 2013 10:27:05 Srinivas KANDAGATLA wrote:
> 
>> > +	soc {
>> > +		pin-controller-sbc {
>> > +			#address-cells	= <1>;
>> > +			#size-cells	= <1>;
>> > +			compatible	= "st,stih416-pinctrl", "simple-bus";
> Why is this both its own device with a compatible string and a
> "simple-bus" at the same time? Wouldn't it be simpler to just
> scan the child device nodes from the "st,stih416-pinctrl"
> driver instead of having a separate platform_driver for them?
> 
I did try this suggestion, and it simplified driver too, I will do this
change in next version.

Thanks,
srini
