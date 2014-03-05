Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532AbaCENE6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 08:04:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44326 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753553AbaCENEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 08:04:55 -0500
Message-ID: <531720EC.7070301@redhat.com>
Date: Wed, 05 Mar 2014 08:04:44 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130108 Thunderbird/10.0.12
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: linux-kernel@vger.kernel.org, Rui Wang <rui.y.wang@intel.com>,
        Michel Lespinasse <walken@google.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Yang Zhang <yang.z.zhang@intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>, janet.morgan@intel.com,
        tony.luck@intel.com, ruiv.wang@gmail.com
Subject: Re: [PATCH] x86, apic, Fix missing replacement for VECTOR_UNDEFINED
References: <1393943271-17447-1-git-send-email-prarit@redhat.com> <alpine.DEB.2.02.1403041436050.5421@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1403041436050.5421@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 03/04/2014 05:37 PM, David Rientjes wrote:
> On Tue, 4 Mar 2014, Prarit Bhargava wrote:
> 
>> linux.git commit 9345005f4eed805308193658d12e4e7e9c261e74 added
>> a definition for VECTOR_UNDEFINED = -1.  There is a missing replacement in
>> the io_apic.c file.  Found during debugging of another issue.
>>
>> Cc: Rui Wang <rui.y.wang@intel.com>
>> Cc: Michel Lespinasse <walken@google.com>
>> Cc: Seiji Aguchi <seiji.aguchi@hds.com>
>> Cc: Yang Zhang <yang.z.zhang@Intel.com>
>> Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
>> Cc: janet.morgan@Intel.com
>> Cc: tony.luck@Intel.com
>> Cc: ruiv.wang@gmail.com
>> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
> 
> Acked-by: David Rientjes <rientjes@google.com>
> 
> I think it would have been better to define VECTOR_UNDEFINED to be (-1) 
> rather than -1, though, to ensure it can't be used erroneously as an 
> arithmetic operation.

Good point David, I'll push a separate patch for your suggestion.  As always,
thanks for acking :)

P.
