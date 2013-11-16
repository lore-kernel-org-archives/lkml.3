Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996Ab3KPIpb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 03:45:31 -0500
Received: from smtp-66.nebula.fi ([83.145.220.66]:52479 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751449Ab3KPIp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 03:45:27 -0500
Date: Sat, 16 Nov 2013 10:45:06 +0200
From: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
To: Jonas Bonn <jonas@southpole.se>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux@openrisc.net,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kevin Mehall <contact@kevinmehall.net>,
        Marek Czerski <ma.czerski@gmail.com>
Subject: Re: [PATCH] openrisc: Add DTS and defconfig for DE0-Nano
Message-ID: <20131116084505.GA26233@chokladfabriken.org>
References: <1384029451-16555-1-git-send-email-geert@linux-m68k.org>
 <5285EE5A.1070202@southpole.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5285EE5A.1070202@southpole.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 10:50:18AM +0100, Jonas Bonn wrote:
> >+
> >+	i2c0: ocores@a0000000 {
> >+		#address-cells = <1>;
> >+		#size-cells = <0>;
> >+		compatible = "opencores,i2c-ocores";
> 
> Version number needed.  OpenCores wanted "projectname-rtlsvn###"
> where ### is the SVN commit number of the RTL directory in the
> project's source repository.
> 

That will also require a change to the driver.

Using svn commit ids as version info seems a bit too fine grained to me,
but if that's what's agreed on, then it should be the commit id from the
projects official repository at opencores.org I think.

Stefan
