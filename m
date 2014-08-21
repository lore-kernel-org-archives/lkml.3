Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbaHUM3a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 08:29:30 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:58642 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679AbaHUM32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 08:29:28 -0400
Message-ID: <53F5E623.5090906@redhat.com>
Date: Thu, 21 Aug 2014 14:29:23 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gleb Natapov <gleb@kernel.org>,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>,
        Vinod Chegu <chegu_vinod@hp.com>, Hui-Zhi <hui-zhi.zhao@hp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH v2 4/6] KVM: VMX: dynamise PLE window
References: <1408567997-21222-1-git-send-email-rkrcmar@redhat.com> <1408567997-21222-5-git-send-email-rkrcmar@redhat.com> <53F5AD3E.3050800@redhat.com> <20140821115405.GD20546@potion.brq.redhat.com>
In-Reply-To: <20140821115405.GD20546@potion.brq.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 21/08/2014 13:54, Radim Krčmář ha scritto:
> Guity as charged.
> Using 0/1 or true/false in this context directly would be pretty bad ...
> Is enum fine? (SHIRINK_PLE_WINDOW, GROW_PLE_WINDOW?)

I prefer good old Ctrl-C Ctrl-V (adjusted for your favorite editor). :)

Paolo
