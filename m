Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503AbaEGIci (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 04:32:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49036 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754544AbaEGIce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 04:32:34 -0400
Message-ID: <5369EF9D.90905@redhat.com>
Date: Wed, 07 May 2014 10:32:29 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Bandan Das <bsd@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 1/4] KVM: emulate: speed up do_insn_fetch
References: <1399400175-23754-1-git-send-email-pbonzini@redhat.com>	<1399400175-23754-2-git-send-email-pbonzini@redhat.com> <jpgk39yiam1.fsf@nelium.bos.redhat.com>
In-Reply-To: <jpgk39yiam1.fsf@nelium.bos.redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 07/05/2014 04:30, Bandan Das ha scritto:
>> > +		if (unlikely(ctxt->_eip == fc->end)) {
> Is this really going to be unlikely ?
>

Yes, it happens at most once per instruction and only for instructions 
that cross pages.

Paolo
