Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300Ab3GKNpT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 09:45:19 -0400
Received: from gate.crashing.org ([63.228.1.57]:33607 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755123Ab3GKNpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 09:45:16 -0400
Message-ID: <1373546290.19894.86.camel@pasglop>
Subject: Re: [PATCH 6/8] KVM: PPC: Add support for multiple-TCE hcalls
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alexander Graf <agraf@suse.de>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org
Date: Thu, 11 Jul 2013 22:38:10 +1000
In-Reply-To: <43E93931-F213-47CC-ADCF-D3A6D6BC4372@suse.de>
References: <1373123227-22969-1-git-send-email-aik@ozlabs.ru>
	 <1373123227-22969-7-git-send-email-aik@ozlabs.ru>
	 <51DC4228.7010607@suse.de> <51DCEA76.9070808@ozlabs.ru>
	 <D10E7B99-3A7C-4275-9A49-3CB15598E705@suse.de> <51DE3ECB.7080803@ozlabs.ru>
	 <43E93931-F213-47CC-ADCF-D3A6D6BC4372@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-11 at 12:11 +0200, Alexander Graf wrote:
> > So I must add one more ioctl to enable MULTITCE in kernel handling. Is it
> > what you are saying?
> > 
> > I can see KVM_CHECK_EXTENSION but I do not see KVM_ENABLE_EXTENSION or
> > anything like that.
> 
> KVM_ENABLE_CAP. It's how we enable sPAPR capabilities too.

But in that case I don't see the point.

Cheers,
Ben.


