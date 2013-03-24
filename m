Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab3CXOBW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 10:01:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21056 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753802Ab3CXOBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 10:01:20 -0400
Date: Sun, 24 Mar 2013 16:01:14 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Scott Wood <scottwood@freescale.com>, Kevin Hilman <khilman@linaro.org>,
        linaro-kernel@lists.linaro.org, Marcelo Tosatti <mtosatti@redhat.com>,
        "open list:KERNEL VIRTUAL MA..." <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: allow host header to be included even for
 !CONFIG_KVM
Message-ID: <20130324140114.GV3889@redhat.com>
References: <1363306426-27209-1-git-send-email-khilman@linaro.org>
 <1363823921.25034.35@snotra>
 <20130321072955.GO3889@redhat.com>
 <87ppyshlq5.fsf@linaro.org>
 <1363891354.31522.17@snotra>
 <20130321191600.GG9382@redhat.com>
 <1363894393.31522.20@snotra>
 <20130321211736.GI9382@redhat.com>
 <CAFTL4hz2=VJBLG1w31JSPDtRdobcmL5oY6XkR46vi3zS904VGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hz2=VJBLG1w31JSPDtRdobcmL5oY6XkR46vi3zS904VGA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 24, 2013 at 02:44:26PM +0100, Frederic Weisbecker wrote:
> 2013/3/21 Gleb Natapov <gleb@redhat.com>:
> > Isn't is simpler for kernel/context_tracking.c to define empty
> > __guest_enter()/__guest_exit() if !CONFIG_KVM.
> 
> That doesn't look right. Off-cases are usually handled from the
> headers, right? So that we avoid iffdeffery ugliness in core code.
Lets put it in linux/context_tracking.h header then.

--
			Gleb.
