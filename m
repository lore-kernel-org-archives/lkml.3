Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296AbaKEJiH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 04:38:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40093 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753764AbaKEJiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 04:38:04 -0500
Message-ID: <5459EFF7.6070405@redhat.com>
Date: Wed, 05 Nov 2014 10:37:59 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Chen, Tiejun" <tiejun.chen@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH] kvm: x86: vmx: avoid returning bool to distinguish success
 from error
References: <1415122394-31986-1-git-send-email-pbonzini@redhat.com> <545980A9.8030405@intel.com>
In-Reply-To: <545980A9.8030405@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 05/11/2014 02:43, Chen, Tiejun wrote:
>>
>> +        default:
>> +            WARN_ON(1);
>> +            continue;
> 
> 'continue' versus 'break'?

Yes, it avoids falling through to "vmcs12_write_any(&vmx->vcpu, field,
field_value)".

> Looks we're missing another place, 

Right, thanks.

Paolo
