Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965804AbaFQQty (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:49:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964870AbaFQQtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:49:52 -0400
Message-ID: <53A07197.2060903@redhat.com>
Date: Tue, 17 Jun 2014 18:49:27 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Bandan Das <bsd@redhat.com>
CC: Nadav Amit <namit@cs.technion.ac.il>, gleb@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] KVM: x86: Wrong emulation on 'xadd X, X'
References: <1402837982-24959-1-git-send-email-namit@cs.technion.ac.il>	<1402837982-24959-3-git-send-email-namit@cs.technion.ac.il>	<jpg7g4gzrdg.fsf@nelium.bos.redhat.com> <539FCF48.5060705@redhat.com> <jpgmwdbv9ab.fsf@redhat.com>
In-Reply-To: <jpgmwdbv9ab.fsf@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 17/06/2014 17:35, Bandan Das ha scritto:
> Well, I meant it more as a review and "suggested changes" to this patchset
> Nadav posted, but yeah, if you prefer, I can post a change myself. I will
> make a pass through other uses of BUG() in the code too.

I'd prefer that, there's no need to make Nadav do even more work.

Paolo
