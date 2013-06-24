Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423Ab3FXM3i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 08:29:38 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:46236 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750884Ab3FXM3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 08:29:35 -0400
Message-ID: <51C83A6D.2060009@st.com>
Date: Mon, 24 Jun 2013 13:24:13 +0100
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
Organization: STMicroelectronics
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stuart Menefy <stuart.menefy@st.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        kernel@stlinux.com,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Stephen Gallimore <stephen.gallimore@st.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3 03/10] pinctrl:st: Add pinctrl and pinconf support.
References: <1371736996-8770-1-git-send-email-srinivas.kandagatla@st.com> <1371737138-9340-1-git-send-email-srinivas.kandagatla@st.com> <51C45816.5010207@st.com> <CACRpkdb-H2=GdF54Fay+PQVdXLTs++L5+QYe_vFPuzpa+E4ZMg@mail.gmail.com>
In-Reply-To: <CACRpkdb-H2=GdF54Fay+PQVdXLTs++L5+QYe_vFPuzpa+E4ZMg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/06/13 12:57, Linus Walleij wrote:
> On Fri, Jun 21, 2013 at 3:41 PM, Srinivas KANDAGATLA
> <srinivas.kandagatla@st.com> wrote:
> 
>> Hi Linus W,
>> If its not too late can this patch be considered for 3.11 via pinctrl tree?
>> There is a build dependecy with regmap_field apis pulled by Mark Brown
>> in regmap repository.
> 
> This seems fairly complete, but I cannot have such a basic dependency onto
> the regmap tree this late in the merge window, i.e. I'm not ready to pull
> all of regmap into the pinctrl tree. I'd consider this for merging
> for the next kernel cycle so it's more orthogonal.
Hmmm..
You mean 3.12*

Am not sure, But..
Is it possible to make just regmap field api patch go via pinctrl tree,
as "Mark Brow" has already accepted it.

Ideally, It would be nice this patch to be part of 3.11-* as, Arnd
already pushed SOC support changes to his next branch.


thanks,
srini

> 
> Yours,
> Linus Walleij
> 

