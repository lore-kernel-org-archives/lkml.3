Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbaCKBCp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 21:02:45 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:57160 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046AbaCKBCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 21:02:43 -0400
Date: Mon, 10 Mar 2014 18:02:40 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Peter Tyser <ptyser@xes-inc.com>
Cc: linux-kernel@vger.kernel.org, James Ralston <james.d.ralston@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH 4/8] mfd: lpc_ich: Add support for iTCO v3
Message-ID: <20140311010240.GD32676@roeck-us.net>
References: <1394487298-14459-1-git-send-email-ptyser@xes-inc.com>
 <1394487298-14459-4-git-send-email-ptyser@xes-inc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394487298-14459-4-git-send-email-ptyser@xes-inc.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 04:34:54PM -0500, Peter Tyser wrote:
> Some newer Atom CPUs, eg Avoton and Bay Trail, use slightly different
> register layouts for the iTCO than the current v1 and v2 iTCO.
> Differences from previous iTCO versions include:
> - The ACPI space is enabled in the "ACPI base address" register instead
>   of the "ACPI control register"
> 
> - The "no reboot" functionality is set in the "Power Management
>   Configuration" register instead of the "General Control and Status"
>   (GCS) register or PCI configuration space.
> 
> - The "ACPI Control Register" is not present on v3.  The "Power
>   Management Configuration Base Address" register resides at the same
>   address is Avoton/Bay Trail.
> 
> To differentiate these newer chipsets create a new v3 iTCO version and
> update the MFD driver to support them.
> 
> Signed-off-by: Peter Tyser <ptyser@xes-inc.com>
> Tested-by: Rajat Jain <rajatjain@juniper.net>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: James Ralston <james.d.ralston@intel.com>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: Wim Van Sebroeck <wim@iguana.be>
> Cc: linux-watchdog@vger.kernel.org

Reviewed-by: Guenter Roeck <linux@roeck-us.net>
