Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750Ab3GKM6X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 08:58:23 -0400
Received: from gate.crashing.org ([63.228.1.57]:35150 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754684Ab3GKM6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 08:58:21 -0400
Message-ID: <1373547480.19894.102.camel@pasglop>
Subject: Re: [PATCH 6/8] KVM: PPC: Add support for multiple-TCE hcalls
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alexander Graf <agraf@suse.de>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org
Date: Thu, 11 Jul 2013 22:58:00 +1000
In-Reply-To: <4133424D-B105-4CB1-A72A-4F47A6184DC7@suse.de>
References: <1373123227-22969-1-git-send-email-aik@ozlabs.ru>
	 <1373123227-22969-7-git-send-email-aik@ozlabs.ru>
	 <51DC4228.7010607@suse.de> <51DCEA76.9070808@ozlabs.ru>
	 <D10E7B99-3A7C-4275-9A49-3CB15598E705@suse.de> <51DE3ECB.7080803@ozlabs.ru>
	 <43E93931-F213-47CC-ADCF-D3A6D6BC4372@suse.de> <51DE8EE9.2000508@ozlabs.ru>
	 <C6BC1E27-4C9C-4A18-A64A-052202DA64B5@suse.de>
	 <1373546368.19894.87.camel@pasglop>
	 <4133424D-B105-4CB1-A72A-4F47A6184DC7@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-11 at 14:51 +0200, Alexander Graf wrote:
> I don't like bloat usually. But Alexey even had an #ifdef DEBUG in
> there to selectively disable in-kernel handling of multi-TCE. Not
> calling ENABLE_CAP would give him exactly that without ugly #ifdefs in
> the kernel.

I don't see much point in disabling it... but ok, if that's a valuable
feature, then shoot some VM level ENABLE_CAP (please don't iterate all
VCPUs, that's gross).

Ben.

