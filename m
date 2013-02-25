Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932495Ab3BYWvi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 17:51:38 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:36336 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932228Ab3BYWvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 17:51:33 -0500
Date: Mon, 25 Feb 2013 14:51:30 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: liguang <lig.fnst@cn.fujitsu.com>
cc: tglx@linutronix.de, hpa@zytor.com, pavel@ucw.cz, rjw@sisk.pl,
        lv.zheng@intel.com, jarkko.sakkinen@intel.com, dave@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        x86@kernel.org
Subject: Re: [rebased-again][PATCH 1/4] acpi: move x86/mm/srat.c to
 x86/kernel/acpi/srat.c
In-Reply-To: <1361759917-5195-2-git-send-email-lig.fnst@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.02.1302251450160.4488@chino.kir.corp.google.com>
References: <1361759917-5195-1-git-send-email-lig.fnst@cn.fujitsu.com> <1361759917-5195-2-git-send-email-lig.fnst@cn.fujitsu.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Feb 2013, liguang wrote:

> srat table should present only on acpi domain,
> seems mm/ is not the right place for it.
> 
> Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>

You're still missing 01a178a94e8e ("acpi, memory-hotplug: support getting 
hotplug info from SRAT") that was merged at the end of last week.  Instead 
of continuing to rebase perhaps it would be better at this point to ask 
the x86 maintainers to just do the patch for you?
