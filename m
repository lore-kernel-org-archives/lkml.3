Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209Ab3I3N7e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 09:59:34 -0400
Received: from rere.qmqm.pl ([89.167.52.164]:39446 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754441Ab3I3N7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 09:59:31 -0400
Date: Mon, 30 Sep 2013 15:59:29 +0200
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: gregkh@linuxfoundation.org, yongjun_wei@trendmicro.com.cn,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc: cb710: drop free_irq for devm_request_irq
 allocated irq
Message-ID: <20130930135929.GA24928@rere.qmqm.pl>
References: <CAPgLHd-C0o3QsJ0TBfn4aE1foWFrwjUy3iSJCkAhgZrfs=e5CQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPgLHd-C0o3QsJ0TBfn4aE1foWFrwjUy3iSJCkAhgZrfs=e5CQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24, 2013 at 10:40:57AM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> irq allocated with devm_request_irq should not be freed using
> free_irq, because doing so causes a dangling pointer, and a
> subsequent double free.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Acked-by: Micha³ Miros³aw <mirq-linux@rere.qmqm.pl>
