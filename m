Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803Ab3FXL6A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 07:58:00 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:63649 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab3FXL54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 07:57:56 -0400
MIME-Version: 1.0
In-Reply-To: <51C45816.5010207@st.com>
References: <1371736996-8770-1-git-send-email-srinivas.kandagatla@st.com>
	<1371737138-9340-1-git-send-email-srinivas.kandagatla@st.com>
	<51C45816.5010207@st.com>
Date: Mon, 24 Jun 2013 13:57:56 +0200
Message-ID: <CACRpkdb-H2=GdF54Fay+PQVdXLTs++L5+QYe_vFPuzpa+E4ZMg@mail.gmail.com>
Subject: Re: [PATCH v3 03/10] pinctrl:st: Add pinctrl and pinconf support.
From: Linus Walleij <linus.walleij@linaro.org>
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 3:41 PM, Srinivas KANDAGATLA
<srinivas.kandagatla@st.com> wrote:

> Hi Linus W,
> If its not too late can this patch be considered for 3.11 via pinctrl tree?
> There is a build dependecy with regmap_field apis pulled by Mark Brown
> in regmap repository.

This seems fairly complete, but I cannot have such a basic dependency onto
the regmap tree this late in the merge window, i.e. I'm not ready to pull
all of regmap into the pinctrl tree. I'd consider this for merging
for the next kernel cycle so it's more orthogonal.

Yours,
Linus Walleij
