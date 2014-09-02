Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbaIBQuW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 12:50:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54495 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753524AbaIBQuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 12:50:14 -0400
Message-ID: <5405F53A.4000705@redhat.com>
Date: Tue, 02 Sep 2014 18:50:02 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: David Matlack <dmatlack@google.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/3] fix bugs with stale or corrupt MMIO caches
References: <1409308277-4021-1-git-send-email-pbonzini@redhat.com> <5405E550.1010201@redhat.com> <CALzav=ceAVpR7kq-K2eX17s9LgC7_ddt83W8yYc_f=zN8Kh6sg@mail.gmail.com>
In-Reply-To: <CALzav=ceAVpR7kq-K2eX17s9LgC7_ddt83W8yYc_f=zN8Kh6sg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 02/09/2014 18:47, David Matlack ha scritto:
>> > Ping?
> Sorry for the delay. I think the patches look good. And patch 3/3 still
> fixes the bug I was originally seeing, so I'm happy :). I just had one
> small comment (see my reply to patch 2/3).
> 

I answered that question now.  Can I add your Reviewed-by and, for patch
3, Tested-by?

Paolo
