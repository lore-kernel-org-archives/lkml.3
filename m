Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900AbaGZUMm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 16:12:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35018 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbaGZUMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 16:12:40 -0400
Date: Sat, 26 Jul 2014 13:12:40 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@wwwdotorg.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>, paul@pwsan.com,
        Arnd Bergmann <arnd@arndb.de>,
        Peter De Schrijver <pdeschrijver@nvidia.com>, arm@kernel.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] platform: Make platform_bus device a platform device
Message-ID: <20140726201240.GB21870@kroah.com>
References: <1406298233-27876-1-git-send-email-pawel.moll@arm.com>
 <1406298233-27876-5-git-send-email-pawel.moll@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406298233-27876-5-git-send-email-pawel.moll@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 03:23:53PM +0100, Pawel Moll wrote:
> ... describing the root of the device tree, so one can write
> a platform driver initializing the platform.

Wait, what do you mean by "one can write a platform driver initializing
the platform"?  I don't understand your end goal here...

thanks,

greg k-h
