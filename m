Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648AbaK1QtA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 11:49:00 -0500
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:39265 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbaK1Qs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 11:48:59 -0500
Date: Fri, 28 Nov 2014 16:48:39 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arm@kernel.org" <arm@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>
Subject: Re: [PATCH v2 RESEND 1/2] ARM: vexpress: Remove non-DT code
Message-ID: <20141128164839.GV3836@n2100.arm.linux.org.uk>
References: <1416939455-1814-1-git-send-email-pawel.moll@arm.com>
 <201411281608.34978.arnd@arndb.de>
 <20141128153026.GU3836@n2100.arm.linux.org.uk>
 <1417189984.4371.12.camel@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417189984.4371.12.camel@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2014 at 03:53:04PM +0000, Pawel Moll wrote:
> To summarize, I believe that setting CONFIG_REGULATOR=y (as in
> vexpress_defconfig) should solve your issue.

It does, thanks.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
