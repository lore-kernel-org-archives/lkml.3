Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758265Ab3EWRJj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 13:09:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62967 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756979Ab3EWRJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 13:09:38 -0400
Date: Thu, 23 May 2013 20:09:27 +0300
From: Gleb Natapov <gleb@redhat.com>
To: David Daney <ddaney@caviumnetworks.com>
Cc: David Daney <ddaney.cavm@gmail.com>, linux-mips@linux-mips.org,
        ralf@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH v5 0/6] mips/kvm: Fix ABI for compatibility with 64-bit
 guests.
Message-ID: <20130523170927.GM26157@redhat.com>
References: <1369248236-27237-1-git-send-email-ddaney.cavm@gmail.com>
 <20130523102834.GN4725@redhat.com>
 <519E4A98.7020903@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <519E4A98.7020903@caviumnetworks.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 09:58:00AM -0700, David Daney wrote:
> On 05/23/2013 03:28 AM, Gleb Natapov wrote:
> >On Wed, May 22, 2013 at 11:43:50AM -0700, David Daney wrote:
> >>From: David Daney <david.daney@cavium.com>
> >>
> >Please regenerate against master. arch/mips/include/asm/kvm.h does not
> >exists any more.
> 
> New patch sent.  I gather from this message, that you want to merge
> this particular set via your tree instead of Ralf's MIPS tree.
> That's fine with me.  However, we were hoping to have these ABI
> fixing patches pushed to Linus before 3.10 releases, so that there
> don't exist kernel versions with the defective ABI.
> 
I do plan to push them to 3.10 that is why I asked to generate them
against master ("next" branch is for next merge window)

> Future patch sets may affect core MIPS architecture files, and
> therefore may not be so amenable to merging via the KVM tree.  We
> will have to figure out how to handle that.
> 
Are you talking about initial MIPS HW vitalization support? Lets see
the patch series. If core changes are to big for for Ralf to ack them
and push through kvm.git then we can push them via MPIS tree.

--
			Gleb.
