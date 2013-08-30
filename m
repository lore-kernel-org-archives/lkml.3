Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab3H3AN7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 20:13:59 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:28400 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391Ab3H3AN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 20:13:58 -0400
Message-ID: <1377821542.10300.869.camel@misato.fc.hp.com>
Subject: Re: [PATCH 0/4] Unify CPU hotplug lock interface
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: mingo@redhat.com, hpa@linux.intel.com, tglx@linutronix.de,
        gregkh@linuxfoundation.org, benh@kernel.crashing.org, x86@kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, bp@suse.de, srivatsa.bhat@linux.vnet.ibm.com,
        isimatu.yasuaki@jp.fujitsu.com
Date: Thu, 29 Aug 2013 18:12:22 -0600
In-Reply-To: <21553065.6VHCMzStpF@vostro.rjw.lan>
References: <1376768819-28975-1-git-send-email-toshi.kani@hp.com>
	 <1449558.tneKXFMIWE@vostro.rjw.lan>
	 <1377796510.10300.868.camel@misato.fc.hp.com>
	 <21553065.6VHCMzStpF@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-30 at 02:06 +0200, Rafael J. Wysocki wrote:
> On Thursday, August 29, 2013 11:15:10 AM Toshi Kani wrote:
> > On Sun, 2013-08-18 at 03:02 +0200, Rafael J. Wysocki wrote:
> > > On Saturday, August 17, 2013 01:46:55 PM Toshi Kani wrote:
> > > > lock_device_hotplug() was recently introduced to serialize CPU & Memory
> > > > online/offline and hotplug operations, along with sysfs online interface
> > > > restructure (commit 4f3549d7).  With this new locking scheme,
> > > > cpu_hotplug_driver_lock() is redundant and is no longer necessary.
> > > > 
> > > > This patchset makes sure that lock_device_hotplug() covers all CPU online/
> > > > offline interfaces, and then removes cpu_hotplug_driver_lock().
> > > > 
> > > > The patchset is based on Linus's tree, 3.11.0-rc5.
> > > 
> > > Nice series, thanks a lot for taking care of this!
> > 
> > Hi Rafael,
> > 
> > Per the recent your changes in lock_device_hotplug(), do you think it
> > makes sense to integrate this patchset into your tree?  I am also
> > considering to add one more patch to use lock_device_hotplug_sysfs() in
> > cpu_probe_store().  I will rebase to your tree and send them today if it
> > makes sense to you.
> 
> Yes, it does to me.

Great!  I will send them shortly.

Thanks,
-Toshi

