Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933524Ab3GWQEa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 12:04:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60900 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932595Ab3GWQE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 12:04:29 -0400
Message-ID: <51EEA96D.3070208@zytor.com>
Date: Tue, 23 Jul 2013 09:03:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: Jason Wang <jasowang@redhat.com>, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, gleb@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] x86: introduce hypervisor_cpuid_base()
References: <1374572465-15278-1-git-send-email-jasowang@redhat.com> <51EE553C.40305@zytor.com> <51EE65F4.3000703@redhat.com>
In-Reply-To: <51EE65F4.3000703@redhat.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2013 04:16 AM, Paolo Bonzini wrote:
> 
> That's nicer, though strcmp is what the replaced code used to do in
> patches 2 and 3.
> 
> Note that memcmp requires the caller to use "KVMKVMKVM\0\0" as the
> signature (or alternatively hypervisor_cpuid_base can copy the argument
> into another 12-byte local variable).
> 

Which is the actual signature, though...

	-hpa


