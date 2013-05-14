Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592Ab3ENIff (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 04:35:35 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:45659 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263Ab3ENIfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 04:35:32 -0400
Subject: Re: [PATCH] efivarfs: Never return ENOENT from firmware again
From: joeyli <jlee@suse.com>
To: Matt Fleming <matt.fleming@intel.com>
Cc: Lingzhu Xiang <lxiang@redhat.com>, Jeremy Kerr <jk@ozlabs.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Josh Boyer <jwboyer@redhat.com>, Andy Whitcroft <apw@canonical.com>
In-Reply-To: <5191E4E0.7020505@intel.com>
References: <5b6476bf31dc699a0e6f3983e78447eeac34d831.1368180585.git.lxiang@redhat.com>
	 <51913D4B.2000606@intel.com> <1368506197.21417.172.camel@linux-s257.site>
	 <5191E4E0.7020505@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 May 2013 16:32:26 +0800
Message-ID: <1368520346.21417.180.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 二，2013-05-14 於 08:16 +0100，Matt Fleming 提到：
> On 05/14/2013 05:36 AM, joeyli wrote:
> > I found the "[PATCH] x86, efi: initial the local variable of DataSize to
> > zero" lost in urgent branch, and it also didn't in Linus's v3.10-rc1.
> > 
> > Did this patch move to other branch?
> 
> It appears I dropped this patch when doing the rebase against -rc1. I'm
> really sorry about that. I've applied it again.

Thanks for your help!

> 
> Thanks for being so diligent.
> --

That because I need apply this patch on v3.9 and v3.10 when debugging
issue on Acer machine.


Thank a lot!
Joey Lee

