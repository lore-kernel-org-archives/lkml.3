Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998AbaHaSeA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 14:34:00 -0400
Received: from asavdk3.altibox.net ([109.247.116.14]:33401 "EHLO
	asavdk3.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbaHaSdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 14:33:54 -0400
Date: Sun, 31 Aug 2014 20:33:42 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, linux-cris-kernel@axis.com,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Mikael Starvik <starvik@axis.com>,
        Grant Likely <grant.likely@linaro.org>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>
Subject: Re: Status of 'cris' architecture support in Linux kernel
Message-ID: <20140831183342.GA25437@ravnborg.org>
References: <20140831175010.GA15408@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140831175010.GA15408@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 31, 2014 at 10:50:10AM -0700, Guenter Roeck wrote:
> The idea was to create a crisv32 kernel and initramfs to work with qemu
> for the ongoing Linux kernel test project.
> 
> After spending a number of days (and nights) on it, the results don't look
> very encouraging.
> 
> My overall conclusion is that 'cris' architecture support in the Linux kernel
> is in bad shape, does not work anymore, and would require substantial effort
> to get it into working state.
> 
> Anyway, below are my individual findings. If there is an ongoing effort to
> improve cris support in the upstream kernel, specifically support for crisv32,
> please let me know. I'll be happy to test the resulting kernels.

Jesper is on parental leave so do not expect any prompt reply from him.

> 
> Individual findings:
> 
> headers_install
> 
> make ARCH=cris INSTALL_HDR_PATH=/tmp headers_install
> 
> results in:
> 
> ./scripts/Makefile.headersinst:14: arch/cris/include/uapi/asm/arch-v10/Kbuild:
> 	No such file or directory
> make[2]: *** No rule to make target `arch/cris/include/uapi/asm/arch-v10/Kbuild'.  Stop.
I have already sent a fix for this that Michael said he wanted to deal with.

	Sam
