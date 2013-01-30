Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514Ab3A3P6L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 10:58:11 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59133 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832Ab3A3P6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 10:58:08 -0500
Date: Wed, 30 Jan 2013 15:57:57 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ruslan Bilovol <ruslan.bilovol@ti.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, tony@atomide.com,
        eduardo.valentin@ti.com
Subject: Re: [RFC PATCH v3 2/2] ARM: OMAP4: setup SoC model name during ID
	initialisation
Message-ID: <20130130155757.GK2637@n2100.arm.linux.org.uk>
References: <1359558091-29251-1-git-send-email-ruslan.bilovol@ti.com> <1359558091-29251-3-git-send-email-ruslan.bilovol@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359558091-29251-3-git-send-email-ruslan.bilovol@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 05:01:31PM +0200, Ruslan Bilovol wrote:
> Set up the SoC model name during OMAP ID initialisation
> so it will be displayed in /proc/cpuinfo:
> 
> / # cat proc/cpuinfo
> [...]
> CPU variant     : 0x2
> CPU part        : 0xc09
> CPU revision    : 10
> 
> SoC name        : OMAP4470

Hmm.  Still not happy.  Wasn't there some SoC infrastructure added to the
kernel to export this kind of information via sysfs?  See:

Documentation/ABI/testing/sysfs-devices-soc
