Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937102Ab3DIJhJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 05:37:09 -0400
Received: from mga03.intel.com ([143.182.124.21]:6794 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763878Ab3DIJhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 05:37:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,438,1363158000"; 
   d="scan'208";a="224961803"
Date: Tue, 9 Apr 2013 11:37:01 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>
Subject: Re: mfd: Core driver for Winbond chips
Message-ID: <20130409093700.GM24058@zurbaran>
References: <1362957300-18223-1-git-send-email-linux@roeck-us.net>
 <20130322205258.GE7867@spo001.leaseweb.com>
 <20130323002810.GA26245@roeck-us.net>
 <20130323174914.GA21563@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130323174914.GA21563@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

On Sat, Mar 23, 2013 at 10:49:14AM -0700, Guenter Roeck wrote:
> MFD core driver for various variants of Winbond/Nuvoton SuperIO chips.
> 
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  drivers/mfd/Kconfig          |   22 +++
>  drivers/mfd/Makefile         |    1 +
>  drivers/mfd/w83627hf-core.c  |  324 ++++++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/w83627hf.h |  131 +++++++++++++++++
>  4 files changed, 478 insertions(+)
>  create mode 100644 drivers/mfd/w83627hf-core.c
>  create mode 100644 include/linux/mfd/w83627hf.h
This driver looks overall good to me. Is this your final version, or should I
expect any follow up patch ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
