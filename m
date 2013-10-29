Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758396Ab3J2QPE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 12:15:04 -0400
Received: from exprod5og113.obsmtp.com ([64.18.0.26]:52940 "HELO
	exprod5og113.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758234Ab3J2QPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 12:15:02 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1310291358150.8257@ionos.tec.linutronix.de>
References: <1382090789-18177-1-git-send-email-vkale@apm.com>
	<CAPrCYke1_RjUgH79vZW99pwdExo4BspCaVi7zL-8hapKb0=gwQ@mail.gmail.com>
	<alpine.DEB.2.02.1310291358150.8257@ionos.tec.linutronix.de>
Date: Tue, 29 Oct 2013 21:45:00 +0530
Message-ID: <CAPrCYkdtUjQAC58uhhFQpCXpA=BVQRA=_kcM+WeOht5uk9hfHQ@mail.gmail.com>
Subject: Re: [PATCH] genirq: error reporting for non-percpu interrupt in request_percpu_irq()
From: Vinayak Kale <vkale@apm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <will.deacon@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Tue, Oct 29, 2013 at 6:29 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Fri, 18 Oct 2013, Vinayak Kale wrote:
>
>> Need for this patch is discussed in mail-thread [1].
>>
>> [1] http://lists.infradead.org/pipermail/linux-arm-kernel/2013-October/204414.html
>>
>
> I can't see anything which makes use of the separate error code in
> that patch.

It was suggested by Will in response to above mentioned patch.
Will's response can be found here:
http://lists.infradead.org/pipermail/linux-arm-kernel/2013-October/204491.html

Sorry for wrong link.

Thanks
-Vinayak
