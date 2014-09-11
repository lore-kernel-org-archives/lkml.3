Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbaIKJIy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 05:08:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36109 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146AbaIKJIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 05:08:51 -0400
Message-ID: <54116699.8080303@redhat.com>
Date: Thu, 11 Sep 2014 11:08:41 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>,
        Chris J Arges <chris.j.arges@canonical.com>, kvm@vger.kernel.org
CC: Gleb Natapov <gleb@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: ioapic: add check for RTC_GSI
References: <1410368033-23628-1-git-send-email-chris.j.arges@canonical.com> <54113AB2.3020801@siemens.com>
In-Reply-To: <54113AB2.3020801@siemens.com>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 11/09/2014 08:01, Jan Kiszka ha scritto:
> That issue is limited to the dead ia64 architecture, no other builds
> ioapic.c (besides x86, of course). Maybe finally remove KVM support for
> that arch instead of bloating otherwise correct code?

Yes, we should.  I've just been too busy to do it.

Paolo
