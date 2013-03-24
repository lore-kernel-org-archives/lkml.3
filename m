Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822Ab3CXNob (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 09:44:31 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:57006 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975Ab3CXNo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 09:44:29 -0400
MIME-Version: 1.0
In-Reply-To: <20130321211736.GI9382@redhat.com>
References: <1363306426-27209-1-git-send-email-khilman@linaro.org>
	<1363823921.25034.35@snotra>
	<20130321072955.GO3889@redhat.com>
	<87ppyshlq5.fsf@linaro.org>
	<1363891354.31522.17@snotra>
	<20130321191600.GG9382@redhat.com>
	<1363894393.31522.20@snotra>
	<20130321211736.GI9382@redhat.com>
Date: Sun, 24 Mar 2013 14:44:26 +0100
Message-ID: <CAFTL4hz2=VJBLG1w31JSPDtRdobcmL5oY6XkR46vi3zS904VGA@mail.gmail.com>
Subject: Re: [PATCH] KVM: allow host header to be included even for !CONFIG_KVM
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: Scott Wood <scottwood@freescale.com>, Kevin Hilman <khilman@linaro.org>,
        linaro-kernel@lists.linaro.org, Marcelo Tosatti <mtosatti@redhat.com>,
        "open list:KERNEL VIRTUAL MA..." <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/21 Gleb Natapov <gleb@redhat.com>:
> Isn't is simpler for kernel/context_tracking.c to define empty
> __guest_enter()/__guest_exit() if !CONFIG_KVM.

That doesn't look right. Off-cases are usually handled from the
headers, right? So that we avoid iffdeffery ugliness in core code.
