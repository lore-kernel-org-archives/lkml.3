Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810AbaHKKDM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 06:03:12 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:46717 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751790AbaHKKDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 06:03:11 -0400
Date: Mon, 11 Aug 2014 11:02:41 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, Chris Ball <chris@printf.net>,
        Anton Vorontsov <anton@enomsg.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "paul@pwsan.com" <paul@pwsan.com>, Arnd Bergmann <arnd@arndb.de>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "arm@kernel.org" <arm@kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH 3/5] mmc: sdhci-pltfm: Do not use parent as the host's
	device
Message-ID: <20140811100241.GB30401@n2100.arm.linux.org.uk>
References: <1406298233-27876-1-git-send-email-pawel.moll@arm.com> <1406298233-27876-3-git-send-email-pawel.moll@arm.com> <1407515785.31897.28.camel@hornet> <CAPDyKFoLU6pnJFmKe7CB0q-hKfwv4uCPSr0cE4aoYMvfhjMteQ@mail.gmail.com> <1407748550.3680.10.camel@hornet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407748550.3680.10.camel@hornet>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 10:15:50AM +0100, Pawel Moll wrote:
> On Mon, 2014-08-11 at 10:07 +0100, Ulf Hansson wrote:
> > Sorry for the delay. I suppose this make sense, but I really don't
> > know for sure.
> > 
> > I guess we need some testing in linux-next, to get some confidence.
> 
> Would you take it into -next then? Unless I'm completely wrong there
> should be no impact on any in-tree driver...

But not until 3.17-rc1 has been released.  linux-next should not receive
new material other than bug fixes while a merge window is open.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
