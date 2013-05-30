Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710Ab3E3NtI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 09:49:08 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:54897 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755861Ab3E3NtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 09:49:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Hanjun Guo <hanjun.guo@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH] ACPI: Fix potential NULL pointer dereference in acpi_processor_add()
Date: Thu, 30 May 2013 15:57:58 +0200
Message-ID: <2969934.XTKV7y9VVT@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51A6B9A2.8090904@linaro.org>
References: <519E0F2A.4070602@linaro.org> <51A5E177.3090809@fold.natur.cuni.cz> <51A6B9A2.8090904@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 30, 2013 10:29:54 AM Hanjun Guo wrote:
> On 2013-5-29 19:07, Martin Mokrejs wrote:
> > Hanjun Guo wrote:
> >> On 2013-5-29 7:30, Rafael J. Wysocki wrote:
> >>> On Thursday, May 23, 2013 08:44:26 PM Hanjun Guo wrote:
> >>>> In acpi_processor_add(), get_cpu_device() will return NULL sometimes,
> >>>> although the chances are small, I think it should be fixed.
> >>>>
> >>>> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> >>>
> >>> This patch isn't necessary any more after the changes queued up for 3.11
> >>> in the acpi-hotplug branch of the linux-pm.git tree.
> >>
> >> Ok, I noticed your patch set, just drop my patch.
> > 
> > But shouldn't this go to stable at least? I checked linux-3.9.4
> > and it applies fine. Whether this is relevant for other stable
> > series I will leave up to somebody else. ;)
> 
> Hi Rafeal,
> 
> What's your opinion on Martin's suggestion?

Well, this is kind of hard to say.  We generally don't apply patches to -stable
that don't have mainline counterparts.

Greg, I wonder what your opinion is?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
