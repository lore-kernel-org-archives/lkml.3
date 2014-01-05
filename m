Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751384AbaAEQIi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 11:08:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44195 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112AbaAEQIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 11:08:37 -0500
Message-ID: <52C9837A.3060308@redhat.com>
Date: Sun, 05 Jan 2014 11:08:26 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Prarit Bhargava <prarit@redhat.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Michel Lespinasse <walken@google.com>,
        Andi Kleen <ak@linux.intel.com>, Seiji Aguchi <seiji.aguchi@hds.com>,
        Yang Zhang <yang.z.zhang@Intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>, janet.morgan@Intel.com,
        tony.luck@Intel.com, ruiv.wang@gmail.com
Subject: Re: [PATCH] x86, Fix do_IRQ interrupt warning for cpu hotplug retriggered
 irqs [v2]
References: <1388938030-16434-1-git-send-email-prarit@redhat.com>
In-Reply-To: <1388938030-16434-1-git-send-email-prarit@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/05/2014 11:07 AM, Prarit Bhargava wrote:
> I tested this by doing a continuous loop of booting a system, downing all
> cpus, and then rebooting.  Before every reboot I grepped the dmesg log for
> the do_IRQ warning to see if there were any additional do_IRQ warnings and
> I do not see any after applying this patch.  I also tested on several
> small and medium sized boxes to confirm that cpu hotplug still works there
> too and do not see any issues.  Please note that this patchset was tested
> in conjunction with 
> 
> http://marc.info/?l=linux-edac&m=138783131400902&w=2
> 
> and
> 
> http://marc.info/?l=linux-kernel&m=138871006718478&w=2
> 
> in order to get cpu hotplug working.
> 
> I'm redoing some additional stability testing (with the additional 2 line
> change in this version of the patch) after down'ing all cpus and
> bringing them back into service, however, I don't expect to see any new issues.
> 
> P.
> 
> ----8<----
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=64831

Oops.  I neglected to update the version in the subject.  Will resend with
appropriate [v3] in a few seconds ...

P.
