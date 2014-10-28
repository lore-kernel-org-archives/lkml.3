Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054AbaJ1OV5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 10:21:57 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:47261 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751204AbaJ1OV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 10:21:56 -0400
Date: Tue, 28 Oct 2014 14:21:45 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Xia Kaixu <kaixu.xia@linaro.org>, arm@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/5] ARM: introduce a CONFIG_ARCH_MULTIPLATFORM_STRICT
 Kconfig option
Message-ID: <20141028142145.GG27405@n2100.arm.linux.org.uk>
References: <1414503095-25986-1-git-send-email-kaixu.xia@linaro.org>
 <1414503095-25986-2-git-send-email-kaixu.xia@linaro.org>
 <71099905.SGyci24BjF@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <71099905.SGyci24BjF@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 03:18:48PM +0100, Arnd Bergmann wrote:
> On Tuesday 28 October 2014 21:31:31 Xia Kaixu wrote:
> >  endmenu
> >  
> > +config ARCH_MULTIPLATFORM_STRICT
> > +        bool "Only allow options that do not break other platforms"
> > +        depends on ARCH_MULTIPLATFORM
> > +        default y
> > +       help
> > +          There are several configuration options that can only work
> > 
> 
> Something seems to be wrong with the whitespace here. Please use tab
> characters for indentation like we do elsewhere in the file.
> 
> Otherwise looks good, I think this is a good step in the right direction.

I totally disagree.  I've raised individual objections on all uses of
this new symbol in separate emails.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
