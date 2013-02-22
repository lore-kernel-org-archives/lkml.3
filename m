Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758780Ab3BVU5N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 15:57:13 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:38255 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944Ab3BVU5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 15:57:09 -0500
Date: Fri, 22 Feb 2013 12:57:06 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: liguang <lig.fnst@cn.fujitsu.com>
cc: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [rebased][PATCH 1/4] acpi: move x86/mm/srat.c to
 x86/kernel/acpi/srat.c
In-Reply-To: <1361511887-29241-2-git-send-email-lig.fnst@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.02.1302221255240.11248@chino.kir.corp.google.com>
References: <1361511887-29241-1-git-send-email-lig.fnst@cn.fujitsu.com> <1361511887-29241-2-git-send-email-lig.fnst@cn.fujitsu.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Feb 2013, liguang wrote:

> srat table should present only on acpi domain,
> seems mm/ is not the right place for it.
> 
> Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>

This is not rebased, it does not have 4819e14ff31e ("acpi, movablemem_map: 
Set numa_nodes_hotplug nodemask when using SRAT info.") but does have 
f7c24b7e1c41 ("acpi, memory-hotplug: support getting hotplug info from 
SRAT"), so I don't know how you're generating these patches.

You're also not sending this to any maintainer who would merge it, so 
please run scripts/get_maintainer.pl on it.
