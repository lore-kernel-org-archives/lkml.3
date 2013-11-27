Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514Ab3K0KIr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 05:08:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14141 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465Ab3K0KIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 05:08:42 -0500
Date: Wed, 27 Nov 2013 12:08:25 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Dan Aloni <alonid@stratoscale.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net, x86@kernel.org,
        pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, Jason Wessel <jason.wessel@windriver.com>
Subject: Re: KVM/KGDB integration
Message-ID: <20131127100825.GR959@redhat.com>
References: <1384872810-29492-1-git-send-email-alonid@stratoscale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384872810-29492-1-git-send-email-alonid@stratoscale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Copying KGDB maintainer to get some feedback.

On Tue, Nov 19, 2013 at 04:53:28PM +0200, Dan Aloni wrote:
> Hello,
> 
> The following two patches address an integration issue between KVM and
> KGDB. The issue described in the patches can be triggered with vanilla
> kernels that enable KGDB and KVM together on x86 (more specifically,
> we bump into this with Fedora's 3.11 kernel from FC19).
> 
> On a kernel enabled with KGDB, running with kvm-unit-tests should
> reproduce the issue. On VM hosts servers where an admin accidently
> left an active KGDB, and unprivilged guest might be able to bring
> the host down.
> 
> Patches apply to linux-next and earlier kernels.

--
			Gleb.
