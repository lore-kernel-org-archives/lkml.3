Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465AbaISOAS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 10:00:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51458 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753398AbaISOAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 10:00:16 -0400
Message-ID: <541C36E8.9020605@redhat.com>
Date: Fri, 19 Sep 2014 16:00:08 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        =?UTF-8?B?UmFkaW0g?= =?UTF-8?B?S3LEjW3DocWZ?= 
	<rkrcmar@redhat.com>
CC: Liang Chen <liangchen.linux@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] KVM: x86: directly use kvm_make_request again
References: <1411058317-23646-1-git-send-email-liangchen.linux@gmail.com> <1411058317-23646-3-git-send-email-liangchen.linux@gmail.com> <541BC949.4050602@linux.vnet.ibm.com> <20140919122502.GA29990@potion.brq.redhat.com> <541C313C.8060402@linux.vnet.ibm.com>
In-Reply-To: <541C313C.8060402@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 19/09/2014 15:35, Xiao Guangrong ha scritto:
>> > Which is why just removing it solves more problems for me :)
> Thank you for raising this question and letting me know the patch's history. :)

I agree with Radim, so I'll apply the patch.

Paolo
