Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208AbaKGQqH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 11:46:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1231 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbaKGQqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 11:46:05 -0500
Message-ID: <545CF733.5020302@redhat.com>
Date: Fri, 07 Nov 2014 17:45:39 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, namit@cs.technion.ac.il
Subject: Re: [PATCH] KVM: x86: save a bit in the decoding flags
References: <1415296011-15062-1-git-send-email-pbonzini@redhat.com> <20141107164337.GA22459@potion.brq.redhat.com>
In-Reply-To: <20141107164337.GA22459@potion.brq.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/11/2014 17:43, Radim Krčmář wrote:
> I think this forces our future AVX implementation to be very hacky,
> we couldn't tell explicitly (un)aligned SSE2/AVX apart.

Ok, I'll apply Nadav's patch them.

Paolo
