Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357AbaCZPqy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 11:46:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17748 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803AbaCZPqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 11:46:52 -0400
Message-ID: <5332F668.8080601@redhat.com>
Date: Wed, 26 Mar 2014 16:46:48 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: Re: [KVM] BUG: unable to handle kernel NULL pointer dereference at
 00000000000002b0
References: <20140326144053.GC26721@localhost> <5332E94B.3050407@redhat.com> <20140326145701.GA27938@localhost>
In-Reply-To: <20140326145701.GA27938@localhost>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 26/03/2014 15:57, Fengguang Wu ha scritto:
>>> > >
>>> > >git://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
>>> > >commit 93c4adc7afedf9b0ec190066d45b6d67db5270da ("KVM: x86: handle missing MPX in nested virtualization")
>> >
>> > Ouch.  Out of curiosity is this on Skylake prototypes, or is it also
>> > visible on some released silicon?
> Paolo, the problem shows up in a Sandybridge-EX and an Ivybridge-EX.

What does that mean in terms of commercial names?  I tested on Sandy 
Bridge Xeon E5.

Paolo
