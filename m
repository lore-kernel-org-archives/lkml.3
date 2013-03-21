Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932580Ab3CULjy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 07:39:54 -0400
Received: from mail-ia0-f171.google.com ([209.85.210.171]:36110 "EHLO
	mail-ia0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932475Ab3CULju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 07:39:50 -0400
MIME-Version: 1.0
In-Reply-To: <1363145021-14339-1-git-send-email-s-anna@ti.com>
References: <1363145021-14339-1-git-send-email-s-anna@ti.com>
Date: Thu, 21 Mar 2013 12:39:49 +0100
Message-ID: <CACRpkdYpJLdTx_sVyLj+MVzXqcyfucyP8qy_b_8jiArU+NSMfQ@mail.gmail.com>
Subject: Re: [PATCHv3 00/14] drivers: mailbox: framework creation
From: Linus Walleij <linus.walleij@linaro.org>
To: Suman Anna <s-anna@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Tony Lindgren <tony@atomide.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Paul Walmsley <paul@pwsan.com>, Benoit Cousson <b-cousson@ti.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org,
        Omar Ramirez Luna <omar.ramirez@copitl.com>,
        Loic Pallardy <loic.pallardy@st.com>,
        Mark Langsdorf <mark.langsdorf@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 4:23 AM, Suman Anna <s-anna@ti.com> wrote:

> Please find the updated mailbox patch series for pulling into linux-next.
> The series is rebased on top of 3.9-rc2, and includes one new patch to
> rename an existing mailbox.h added as part of the highbank cpufreq
> support for 3.9 merge window [1].

ARM SoC folks:

would you consider pulling this stuff into the ARM SoC tree?

It turns out that ux500 multiplatform support is sort of relying
on this refactoring since it helps us to break apart the huge
PRCMU driver.

I am proceeding with my multiplatform work but things like
this not being upstream will make the patches look ugly
and I cannot quite consider it properly done before this is
fixed too.

Yours,
Linus Walleij
