Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687AbaC0MFl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 08:05:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48763 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756624AbaC0MFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 08:05:40 -0400
Message-ID: <5334140F.4020805@redhat.com>
Date: Thu, 27 Mar 2014 13:05:35 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jet Chen <jet.chen@intel.com>, linux-kernel@vger.kernel.org
CC: fengguang.wu@intel.com, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: vmx: fix MPX detection
References: <1395845640-1976-1-git-send-email-pbonzini@redhat.com> <5333E1F9.6010805@intel.com>
In-Reply-To: <5333E1F9.6010805@intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 27/03/2014 09:31, Jet Chen ha scritto:
> Hi Paolo,
>
> I helped to test for your patch on our LKP system. It fixes the bug
> reported by Fengguang.
>
> I applied your patch based on commit
> 93c4adc7afedf9b0ec190066d45b6d67db5270da.

Thanks Jet!

Paolo
