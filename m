Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422728Ab3FTTBa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 15:01:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:54701 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161288Ab3FTTB2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 15:01:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Subject: Re: [PATCH v3 01/10] serial:st-asc: Add ST ASC driver.
Date: Thu, 20 Jun 2013 21:01:10 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stuart Menefy <stuart.menefy@st.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        kernel@stlinux.com, linux-serial@vger.kernel.org,
        Mark Brown <broonie@kernel.org>,
        Stephen Gallimore <stephen.gallimore@st.com>
References: <1371736996-8770-1-git-send-email-srinivas.kandagatla@st.com> <1371737103-8871-1-git-send-email-srinivas.kandagatla@st.com>
In-Reply-To: <1371737103-8871-1-git-send-email-srinivas.kandagatla@st.com>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201306202101.11261.arnd@arndb.de>
X-Provags-ID: V02:K0:GFMFSfBv3mH4lSZxJzwhFSDaJJosI1FHrYs8xA4CpIL
 QoioucU4ClU7JenwLYd+Hutudj0WpwZZziSz/tBHSnYKQCHzVK
 Cnc1igrDobAezRDv6R7SUG8Ny35BdsPLIp7odicVbYtKqbTwP9
 0BabfrsEfmLzELq+9cTqQScocCdpOsBh9CbtI4hUoJ+K4nNADl
 SnC/YdcjvCA/z/nrifNQHRXQ2rJ8yPqgHKo9UKM7JqmRLSXhrx
 HAYy3vquyR/6G6I2s4bzS9yNqRfY4g+0ijrenEdnsCmg2m+NXW
 4t0Dv7z9KI8JBO6M7M+TKbojWF4YXtxJD6yL8x18IedOt6wI9Y
 6T+7fGdBKuybga3rJpGQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 June 2013, Srinivas KANDAGATLA wrote:
> This patch adds support to ASC (asynchronous serial controller)
> driver, which is basically a standard serial driver. This IP is common
> across all the ST parts for settop box platforms.
> 
> ASC is embedded in ST COMMS IP block. It supports Rx & Tx functionality.
> It support all industry standard baud rates.
> 
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> CC: Stephen Gallimore <stephen.gallimore@st.com>
> CC: Stuart Menefy <stuart.menefy@st.com>
> CC: Arnd Bergmann <arnd@arndb.de>
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

>From my point of view the series is ready for merging in 3.11,
I only had a few final comments. I would prefer the first three
patches to go through the respective serial/clocksource/pinctrl
trees, since there are no direct build dependencies to the
platform parts.

If there is a reason to take those through arm-soc, I would
insist on getting Acked-by's from the subsystem maintainers.

	Arnd
