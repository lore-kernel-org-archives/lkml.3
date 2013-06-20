Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab3FTITd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 04:19:33 -0400
Received: from mail-qe0-f50.google.com ([209.85.128.50]:39512 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755422Ab3FTIT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 04:19:28 -0400
Message-ID: <51C2BB08.3080409@redhat.com>
Date: Thu, 20 Jun 2013 10:19:20 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>, gleb@redhat.com,
        avi.kivity@gmail.com, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 7/7] KVM: MMU: document fast invalidate all mmio sptes
References: <1371632965-20077-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1371632965-20077-8-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1371705681.2776.131@driftwood>
In-Reply-To: <1371705681.2776.131@driftwood>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 20/06/2013 07:21, Rob Landley ha scritto:
> On 06/19/2013 04:09:25 AM, Xiao Guangrong wrote:
>> Document it to Documentation/virtual/kvm/mmu.txt
> 
> Why break a change to a single documentation file into 7 pieces.
> 
> Are we going to bisect the documentation?

It is explaining 7 different optimizations, and each patch could have
been submitted together with the corresponding optimization.  So it
makes sense---and it certainly helped review.

Paolo
