Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161486Ab3FUOBe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 10:01:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58353 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161346Ab3FUOBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 10:01:30 -0400
Date: Fri, 21 Jun 2013 07:02:11 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        kernel@stlinux.com, linux-doc@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Gallimore <stephen.gallimore@st.com>,
        Stuart Menefy <stuart.menefy@st.com>, Mark Brown <broonie@kernel.org>,
        John Stultz <john.stultz@linaro.org>, Rob Landley <rob@landley.net>,
        linux-serial@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Jiri Slaby <jslaby@suse.cz>,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 01/10] serial:st-asc: Add ST ASC driver.
Message-ID: <20130621140211.GA995@kroah.com>
References: <1371736996-8770-1-git-send-email-srinivas.kandagatla@st.com>
 <1371737103-8871-1-git-send-email-srinivas.kandagatla@st.com>
 <201306202101.11261.arnd@arndb.de>
 <51C45A3F.7000009@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51C45A3F.7000009@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 02:50:55PM +0100, Srinivas KANDAGATLA wrote:
> Hi Greg,
> If its not too late can this patch be considered for 3.11 via tty tree?
> Arnd preferred to take the SOC patches in this series via arm-soc tree.
> Also, there is no build dependency for this patch.

Can you please resend it, I no longer seem to have it in my queue
anywhere.

thanks,

greg k-h
