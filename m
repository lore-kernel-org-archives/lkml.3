Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab3BDToh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 14:44:37 -0500
Received: from mail-da0-f44.google.com ([209.85.210.44]:53900 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755528Ab3BDTog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 14:44:36 -0500
Date: Mon, 4 Feb 2013 11:44:34 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: liguang <lig.fnst@cn.fujitsu.com>
cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 3/5] acpi: move x86/mm/srat.c to x86/kernel/acpi/srat.c
In-Reply-To: <1359967426-32629-4-git-send-email-lig.fnst@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.02.1302041142550.10378@chino.kir.corp.google.com>
References: <1359967426-32629-1-git-send-email-lig.fnst@cn.fujitsu.com> <1359967426-32629-4-git-send-email-lig.fnst@cn.fujitsu.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Feb 2013, liguang wrote:

> srat table should present only on acpi domain,
> seems mm/ is not the right place for it.
> 
> Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
> ---
>  arch/x86/kernel/acpi/Makefile |    1 +
>  arch/x86/mm/Makefile          |    1 -
>  arch/x86/mm/srat.c            |  191 -----------------------------------------
>  3 files changed, 1 insertions(+), 192 deletions(-)
>  delete mode 100644 arch/x86/mm/srat.c
> 

I was excited for a moment because this would have been one great cleanup, 
but you never readded the code to arch/x86/kernel/acpi.  (You probably 
need to do "git add <newfile>" before generating the patch file.)  I do 
like the idea of moving it, though, if it's build tested thoroughly.
