Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317Ab3EQBOo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 21:14:44 -0400
Received: from ozlabs.org ([203.10.76.45]:33678 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754791Ab3EQBOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 21:14:42 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Amit Shah <amit.shah@redhat.com>,
        Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, anup.patel@linaro.org
Subject: Re: [PATCH V2 1/3] virtio: console: Add emergency writeonly register to config space
In-Reply-To: <20130516123746.GA4744@amit.redhat.com>
References: <1367842791-30285-1-git-send-email-pranavkumar@linaro.org> <1367842791-30285-2-git-send-email-pranavkumar@linaro.org> <20130516123746.GA4744@amit.redhat.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Fri, 17 May 2013 09:22:58 +0930
Message-ID: <871u96a3dx.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amit Shah <amit.shah@redhat.com> writes:
> On (Mon) 06 May 2013 [17:49:49], Pranavkumar Sawargaonkar wrote:
>> This patch adds an emerg_wr register (writeonly) in config space
>> of virtio console device which can be used for debugging.
>> 
>> Signed-off-by: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
>> Signed-off-by: Anup Patel <anup.patel@linaro.org>
>> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
>
> OK, this change by itself looks harmless.
>
> Acked-by: Amit Shah <amit.shah@redhat.com>
>
> 		Amit

Thanks.  This is queued for *next* merge window.

Cheers,
Rusty.
