Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060Ab3EaMAE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 08:00:04 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:55481 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755944Ab3EaL7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 07:59:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH] ACPI: Fix potential NULL pointer dereference in acpi_processor_add()
Date: Fri, 31 May 2013 14:08:40 +0200
Message-ID: <2938460.ha3GPv9q9Y@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51A81FF9.8030403@linaro.org>
References: <519E0F2A.4070602@linaro.org> <20130530222542.GD1630@kroah.com> <51A81FF9.8030403@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 31, 2013 11:58:49 AM Hanjun Guo wrote:
> On 2013-5-31 6:25, Greg Kroah-Hartman wrote:
> > On Thu, May 30, 2013 at 03:57:58PM +0200, Rafael J. Wysocki wrote:
> >> On Thursday, May 30, 2013 10:29:54 AM Hanjun Guo wrote:
> >>> On 2013-5-29 19:07, Martin Mokrejs wrote:
> >>>> Hanjun Guo wrote:
> >>>>> On 2013-5-29 7:30, Rafael J. Wysocki wrote:
> >>>>>> On Thursday, May 23, 2013 08:44:26 PM Hanjun Guo wrote:
> >>>>>>> In acpi_processor_add(), get_cpu_device() will return NULL sometimes,
> >>>>>>> although the chances are small, I think it should be fixed.
> >>>>>>>
> >>>>>>> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> >>>>>>
> >>>>>> This patch isn't necessary any more after the changes queued up for 3.11
> >>>>>> in the acpi-hotplug branch of the linux-pm.git tree.
> >>>>>
> >>>>> Ok, I noticed your patch set, just drop my patch.
> >>>>
> >>>> But shouldn't this go to stable at least? I checked linux-3.9.4
> >>>> and it applies fine. Whether this is relevant for other stable
> >>>> series I will leave up to somebody else. ;)
> >>>
> >>> Hi Rafeal,
> >>>
> >>> What's your opinion on Martin's suggestion?
> >>
> >> Well, this is kind of hard to say.  We generally don't apply patches to -stable
> >> that don't have mainline counterparts.
> >>
> >> Greg, I wonder what your opinion is?
> > 
> > We do not apply patches to -stable that are not in Linus's tree, unless
> > there is no problem in Linus's tree due to a major rewrite of the code,
> > and it has been confirmed that the same problem isn't there.
> 
> Hi Rafael,
> 
> I found that the problem is still there in your acpi-hotplug tree, sorry for
> I didn't noticed early. I made a patch for this again, I hope it will make
> sense to you.
> 
> The patch is attached, based on your acpi-hotplug tree.

OK, thanks!

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
