Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759290Ab3EBN5x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 09:57:53 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:35346 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab3EBN5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 09:57:51 -0400
Date: Thu, 2 May 2013 06:57:45 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Toshi Kani <toshi.kani@hp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, isimatu.yasuaki@jp.fujitsu.com,
        vasilis.liaskovitis@profitbricks.com, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 2/4] Driver core: Use generic offline/online for CPU
 offline/online
Message-ID: <20130502135745.GB24095@kroah.com>
References: <1576321.HU0tZ4cGWk@vostro.rjw.lan>
 <3166726.elbgrUIZ0L@vostro.rjw.lan>
 <14113724.8SqWXP0sFF@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14113724.8SqWXP0sFF@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 02, 2013 at 02:28:19PM +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Rework the CPU hotplug code in drivers/base/cpu.c to use the
> generic offline/online support introduced previously instead of
> its own CPU-specific code.
> 
> For this purpose, modify cpu_subsys to provide offline and online
> callbacks for CONFIG_HOTPLUG_CPU set and remove the code handling
> the CPU-specific 'online' sysfs attribute.
> 
> This modification is not supposed to change the user-observable
> behavior of the kernel (i.e. the 'online' attribute will be present
> in exactly the same place in sysfs and should trigger exactly the
> same actions as before).
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
