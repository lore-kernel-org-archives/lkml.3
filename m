Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab3FBQaK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 12:30:10 -0400
Received: from mb2i1mx.ns.pitt.edu ([136.142.11.142]:52990 "EHLO
	mb2i1.ns.pitt.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753931Ab3FBQaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 12:30:04 -0400
X-Greylist: delayed 567 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Jun 2013 12:30:04 EDT
Date: Sun, 02 Jun 2013 09:20:34 -0700
From: Jiannan Ouyang <ouyang@cs.pitt.edu>
Subject: Re: [PATCH RFC V9 0/19] Paravirtualized ticket spinlocks
In-reply-to: <20130602080739.GA24773@redhat.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
        x86@kernel.org, konrad.wilk@oracle.com,
        "H. Peter Anvin" <hpa@zytor.com>, pbonzini@redhat.com,
        linux-doc@vger.kernel.org,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        xen-devel@lists.xensource.com, Peter Zijlstra <peterz@infradead.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        stefano.stabellini@eu.citrix.com, andi@firstfloor.org,
        attilio.rao@citrix.com, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        gregkh@suse.de, agraf@suse.de, chegu vinod <chegu_vinod@hp.com>,
        torvalds@linux-foundation.org, Avi Kivity <avi.kivity@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, KVM <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, stephan.diestelhorst@amd.com,
        Rik van Riel <riel@redhat.com>, Andrew Jones <drjones@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>
Message-id: <CAJocwcf0oykyLv4B22pBf1A3H7+Cs6qu0vmTWp46Z=KwrTkXyQ@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
References: <20130601192125.5966.35563.sendpatchset@codeblue>
 <20130602080739.GA24773@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 2, 2013 at 1:07 AM, Gleb Natapov <gleb@redhat.com> wrote:

> High level question here. We have a big hope for "Preemptable Ticket
> Spinlock" patch series by Jiannan Ouyang to solve most, if not all,
> ticketing spinlocks in overcommit scenarios problem without need for PV.
> So how this patch series compares with his patches on PLE enabled processors?
>

No experiment results yet.

An error is reported on a 20 core VM. I'm during an internship
relocation, and will start work on it next week.

--
Jiannan
