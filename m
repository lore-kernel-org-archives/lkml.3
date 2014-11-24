Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495AbaKXKpn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 05:45:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092AbaKXKpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 05:45:40 -0500
Message-ID: <54730C45.6060708@redhat.com>
Date: Mon, 24 Nov 2014 11:45:25 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH] KVM: x86: export get_xsave_addr
References: <1416823471-30846-1-git-send-email-pbonzini@redhat.com> <alpine.DEB.2.11.1411241144220.6439@nanos>
In-Reply-To: <alpine.DEB.2.11.1411241144220.6439@nanos>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 24/11/2014 11:45, Thomas Gleixner wrote:
> On Mon, 24 Nov 2014, Paolo Bonzini wrote:
>> get_xsave_addr is the API to access XSAVE states, and KVM would
>> like to use it.  Export it.
>>
>> Cc: x86@kernel.org
>> Cc: H. Peter Anvin <hpa@linux.intel.com>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>> 	Peter, can you please ACK this for inclusion in the KVM tree?
> 
> Are you content with my acked-by as well?
> 
> Acked-by: Thomas Gleixner <tglx@linutronix.de>

Sure. :)

Paolo
