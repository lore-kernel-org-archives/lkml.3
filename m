Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761Ab3BTHAN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 02:00:13 -0500
Received: from mail-da0-f45.google.com ([209.85.210.45]:50843 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756456Ab3BTHAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 02:00:11 -0500
Date: Tue, 19 Feb 2013 23:00:08 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: li guang <lig.fnst@cn.fujitsu.com>
cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, x86@kernel.org,
        isimatu.yasuaki@jp.fujitsu.com
Subject: Re: [PATCH v4 1/4] acpi: move x86/mm/srat.c to
 x86/kernel/acpi/srat.c
In-Reply-To: <1361330196.7859.51.camel@liguang.fnst.cn.fujitsu.com>
Message-ID: <alpine.DEB.2.02.1302192254440.27407@chino.kir.corp.google.com>
References: <1360894992-14818-1-git-send-email-lig.fnst@cn.fujitsu.com> <1360894992-14818-2-git-send-email-lig.fnst@cn.fujitsu.com> <alpine.DEB.2.02.1302191320410.6322@chino.kir.corp.google.com> <1361324355.7859.35.camel@liguang.fnst.cn.fujitsu.com>
 <1361325113.7859.37.camel@liguang.fnst.cn.fujitsu.com> <alpine.DEB.2.02.1302191802490.14999@chino.kir.corp.google.com> <1361326913.7859.41.camel@liguang.fnst.cn.fujitsu.com> <1361327201.7859.44.camel@liguang.fnst.cn.fujitsu.com>
 <alpine.DEB.2.02.1302191902470.18957@chino.kir.corp.google.com> <1361330196.7859.51.camel@liguang.fnst.cn.fujitsu.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2013, li guang wrote:

> Yes, I know there's no new changes in my patch as I said before(not
> based on lasted), but as I try to apply my patch(1/4), it will do
> the right work to move current srat.c from arch/x86/mm/ to
> arch/x86/kernel/acpi/ regardless of what I based is not latest.
> 

Sorry, but that makes no sense.  Your patch cannot be used cleanly if 
there have been subsequent changes to a hunk prior to applying it -- in 
this case the hunk would be the entire file since you're removing it.

These patches would also be pushed by the x86 maintainers, who are not 
cc'd on this patch, and I think it would be unfair to ask them to make up 
for your inability to generate a bleeding edge patch with linux-next.  The 
changes already cited in this thread have been in linux-next for almost 
two weeks, yet you refuse to rebase on top of them.
