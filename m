Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932888AbaLDR3W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 12:29:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60559 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932219AbaLDR3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 12:29:21 -0500
Message-ID: <548099DF.4080202@redhat.com>
Date: Thu, 04 Dec 2014 18:29:03 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, rkrcmar@redhat.com,
        Wanpeng Li <wanpeng.li@linux.intel.com>, stable@vger.kernel.org,
        x86@kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH 1/9] x86: export get_xsave_addr
References: <1417708634-24333-1-git-send-email-pbonzini@redhat.com> <1417708634-24333-2-git-send-email-pbonzini@redhat.com> <20141204163443.GA1477@kroah.com>
In-Reply-To: <20141204163443.GA1477@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/12/2014 17:34, Greg KH wrote:
> On Thu, Dec 04, 2014 at 04:57:06PM +0100, Paolo Bonzini wrote:
>> > get_xsave_addr is the API to access XSAVE states, and KVM would
>> > like to use it.  Export it.
> Use it in what way?

As in patch 2/9, to avoid that upgrading to a newer processor breaks
userspace ABI.

>> > Cc: stable@vger.kernel.org
> Why is this a stable patch?

Because as of now, Skylake processors have a different userspace ABI
than previous generations.

Paolo
