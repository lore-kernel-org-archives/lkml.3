Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632AbaCOUDO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 16:03:14 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:34008 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755571AbaCOUDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 16:03:12 -0400
Date: Sat, 15 Mar 2014 21:03:09 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Peter Tyser <ptyser@xes-inc.com>
Cc: linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        James Ralston <james.d.ralston@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH 5/8] watchdog: iTCO_wdt: Add support for v3 silicon
Message-ID: <20140315200309.GC14815@spo001.leaseweb.com>
References: <1394487298-14459-1-git-send-email-ptyser@xes-inc.com> <1394487298-14459-5-git-send-email-ptyser@xes-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394487298-14459-5-git-send-email-ptyser@xes-inc.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

> Some new Atom's, eg Avoton and Bay Trail, have slightly different iTCO
> functionality:
> - The watchdog timer ticks at 1 second instead of .6 seconds
> 
> - Some 8 and 16-bit registers were combined into 32-bit registers
> 
> - Some registers were removed (DAT_IN, DAT_OUT, MESSAGE)
> 
> - The BOOT_STS field in TCO_STS was removed
> 
> - The NO_REBOOT bit is in the PMC area instead of GCS
> 
> Update the driver to support the above changes and bump the version to
> 1.11.
> 
> Signed-off-by: Peter Tyser <ptyser@xes-inc.com>
> Tested-by: Rajat Jain <rajatjain@juniper.net>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: James Ralston <james.d.ralston@intel.com>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: Wim Van Sebroeck <wim@iguana.be>
> Cc: linux-watchdog@vger.kernel.org

Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Kind regards,
Wim.

