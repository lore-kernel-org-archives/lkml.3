Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932759AbaKURFN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 12:05:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932501AbaKURFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 12:05:09 -0500
Message-ID: <546F70BF.30509@redhat.com>
Date: Fri, 21 Nov 2014 18:05:03 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] kvm: x86: move ioapic.c and irq_comm.c back to arch/x86/
References: <1416490931-21724-1-git-send-email-pbonzini@redhat.com> <20141121161956.GA16941@potion.brq.redhat.com>
In-Reply-To: <20141121161956.GA16941@potion.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/11/2014 17:19, Radim Krčmář wrote:
> KVM: x86: remove IA64 from ioapic.c and irq_comm.c
> 
> They won't get compiled in x86 tree.

Ah no, these were already in my ia64 removal patch.  I had a deja-vu
feeling...

Paolo
