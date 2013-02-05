Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542Ab3BEFfZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 00:35:25 -0500
Received: from mail-da0-f44.google.com ([209.85.210.44]:46076 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072Ab3BEFfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 00:35:23 -0500
Date: Mon, 4 Feb 2013 21:35:18 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: liguang <lig.fnst@cn.fujitsu.com>
cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v2 1/4] acpi: move x86/mm/srat.c to
 x86/kernel/acpi/srat.c
In-Reply-To: <1360031838-26898-2-git-send-email-lig.fnst@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.02.1302042131400.31498@chino.kir.corp.google.com>
References: <1360031838-26898-1-git-send-email-lig.fnst@cn.fujitsu.com> <1360031838-26898-2-git-send-email-lig.fnst@cn.fujitsu.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2013, liguang wrote:

> srat table should present only on acpi domain,
> seems mm/ is not the right place for it.
> 
> Reviewed-by: David Rientjes <rientjes@google.com>

I certainly didn't review this, please read 
Documentation/SubmittingPatches.

> Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>

Couple of issues with this:

 - it doesn't include your followup change "acpi: change Makefile for
   srat.c building" which is required for this to build, please fold it in 
   and repost,

 - there is whitespace damage, we use tabs for indentation in Makefiles,

 - you're basing your patches on Linus' tree when arch/x86/mm/srat has
   changed in linux-next (15 insertions(+), 14 deletions(-)), please 
   rebase this on the linux-next tree at git.kernel.org.

Otherwise, looks good.
