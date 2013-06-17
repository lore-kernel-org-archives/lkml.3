Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222Ab3FQS4J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 14:56:09 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:34950 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603Ab3FQS4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 14:56:06 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        alsa-devel@alsa-project.org, Kukjin Kim <kgene.kim@samsung.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Padmavathi Venna <padma.v@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Alban Bedel <alban.bedel@avionic-design.de>
Subject: Re: [RFC PATCH 01/11] dma: amba-pl08x: Use bitmap to pass variant specific quirks
Date: Mon, 17 Jun 2013 20:56:06 +0200
Message-ID: <12368941.dQe8bcScGj@flatron>
User-Agent: KMail/4.10.4 (Linux/3.9.5-gentoo; KDE/4.10.4; x86_64; ; )
In-Reply-To: <20130617184856.GN2718@n2100.arm.linux.org.uk>
References: <1371416058-22047-1-git-send-email-tomasz.figa@gmail.com> <1371416058-22047-2-git-send-email-tomasz.figa@gmail.com> <20130617184856.GN2718@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 of June 2013 19:48:56 Russell King - ARM Linux wrote:
> On Sun, Jun 16, 2013 at 10:54:08PM +0200, Tomasz Figa wrote:
> > Instead of defining new bool field in vendor_data struct for each
> > quirk, it is more reasonable to use a single flags field and make
> > each quirk use single bits.
> 
> Please explain why this is better over the existing system, and why it
> is not just churn for code modification's sake.

It isn't anything important. I just thought that this is a better solution 
to store more than just two flags. Initially I had more of them added in 
further patches, but final version ended with just one, so this can be 
dropped.

Best regards,
Tomasz

