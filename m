Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496Ab3LTLad (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 06:30:33 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:49503 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755831Ab3LTLaa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 06:30:30 -0500
Date: Fri, 20 Dec 2013 11:29:55 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: joeyli <jlee@suse.com>
Cc: Matt Fleming <matt@console-pimps.org>, JBeulich@suse.com,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        x86@kernel.org,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-acpi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH 02/14] x86-64/efi: Use EFI to deal with platform wall
 clock (again)
Message-ID: <20131220112955.75e82a86@alan.etchedpixels.co.uk>
In-Reply-To: <1387459939.3539.4092.camel@linux-s257.site>
References: <1387439515-8926-1-git-send-email-jlee@suse.com>
	<1387448416-11672-1-git-send-email-jlee@suse.com>
	<20131219104908.GE3145@console-pimps.org>
	<1387459939.3539.4092.camel@linux-s257.site>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Dec 2013 21:32:19 +0800
joeyli <jlee@suse.com> wrote:

> 於 四，2013-12-19 於 10:49 +0000，Matt Fleming 提到：
> > On Thu, 19 Dec, at 06:20:16PM, Lee, Chun-Yi wrote:
> > > From: Jan Beulich <JBeulich@suse.com>
> > > 
> > > Other than ix86, x86-64 on EFI so far didn't set the
> > > {g,s}et_wallclock accessors to the EFI routines, thus
> > > incorrectly using raw RTC accesses instead.

Probably wise.

Before anyone reverts that please make sure it also works on EFI32,
because right now we crash and burn on multiple EFI32 tablets querying
the time.

Alan
