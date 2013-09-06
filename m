Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668Ab3IFOWQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 10:22:16 -0400
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:60728 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751568Ab3IFOWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 10:22:15 -0400
Date: Fri, 6 Sep 2013 07:22:14 -0700 (PDT)
From: Andy King <acking@vmware.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: gregkh@linuxfoundation.org, dtor@vmware.com, georgezhang@vmware.com,
        asarwade@vmware.com, yongjun wei <yongjun_wei@trendmicro.com.cn>,
        linux-kernel@vger.kernel.org
Message-ID: <169897777.45173847.1378477334081.JavaMail.root@vmware.com>
In-Reply-To: <CAPgLHd8FyR_bdD75ETukz491+yDtOV7c4o2hmPbU0Y2L_3dm1g@mail.gmail.com>
References: <CAPgLHd8FyR_bdD75ETukz491+yDtOV7c4o2hmPbU0Y2L_3dm1g@mail.gmail.com>
Subject: Re: [PATCH] VMCI: fix to pass correct device identity to free_irq()
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.163.68]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - GC28 (Linux)/8.0.3_GA_5664)
Thread-Topic: VMCI: fix to pass correct device identity to free_irq()
Thread-Index: +2f5lMVn1YRrzui6smebJyQIjVOOAw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> free_irq() expects the same device identity that was passed to
> corresponding request_irq(), otherwise the IRQ is not freed.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Acked-by: Andy King <acking@vmware.com>

Thanks for fixing this!
- Andy
