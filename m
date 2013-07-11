Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932402Ab3GKMkm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 08:40:42 -0400
Received: from gate.crashing.org ([63.228.1.57]:44972 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932082Ab3GKMkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 08:40:39 -0400
Message-ID: <1373546418.19894.88.camel@pasglop>
Subject: Re: [PATCH 6/8] KVM: PPC: Add support for multiple-TCE hcalls
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alexander Graf <agraf@suse.de>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org
Date: Thu, 11 Jul 2013 22:40:18 +1000
In-Reply-To: <C6BC1E27-4C9C-4A18-A64A-052202DA64B5@suse.de>
References: <1373123227-22969-1-git-send-email-aik@ozlabs.ru>
	 <1373123227-22969-7-git-send-email-aik@ozlabs.ru>
	 <51DC4228.7010607@suse.de> <51DCEA76.9070808@ozlabs.ru>
	 <D10E7B99-3A7C-4275-9A49-3CB15598E705@suse.de> <51DE3ECB.7080803@ozlabs.ru>
	 <43E93931-F213-47CC-ADCF-D3A6D6BC4372@suse.de> <51DE8EE9.2000508@ozlabs.ru>
	 <C6BC1E27-4C9C-4A18-A64A-052202DA64B5@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-11 at 13:15 +0200, Alexander Graf wrote:
> There are 2 ways of dealing with this:
> 
>   1) Call the ENABLE_CAP on every vcpu. That way one CPU may handle
> this hypercall in the kernel while another one may not. The same as we
> handle PAPR today.
> 
>   2) Create a new ENABLE_CAP for the vm.
> 
> I think in this case option 1 is fine - it's how we handle everything
> else already.

So, you are now asking him to chose between a gross horror or adding a
new piece of infrastructure for something that is entirely pointless to
begin with ?

Come on, give him a break. That stuff is fine as it is.

Ben.


