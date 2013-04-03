Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761017Ab3DCDDu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 23:03:50 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:45573 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757997Ab3DCDDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 23:03:49 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID r3333fae027073, This message is released by code: ctlocs8528
From: hayeswang <hayeswang@realtek.com>
To: "'Francois Romieu'" <romieu@fr.zoreil.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1364824539-4156-1-git-send-email-hayeswang@realtek.com> <1364891022-3220-1-git-send-email-hayeswang@realtek.com> <1364891022-3220-6-git-send-email-hayeswang@realtek.com> <20130402222728.GA16612@electric-eye.fr.zoreil.com>
Subject: RE: [PATCH v2 net-next 6/8] r8169: add a new chip for RTL8111G
Date: Wed, 3 Apr 2013 11:03:45 +0800
Message-ID: <5A289D0C2A6C44158FB4CC5226F8E920@realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: Ac4v8UUWTEXe4kX2Q3ayRvqzyhF/vQAIlu0g
In-Reply-To: <20130402222728.GA16612@electric-eye.fr.zoreil.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6157
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Francois Romieu [mailto:romieu@fr.zoreil.com] 
> Sent: Wednesday, April 03, 2013 6:27 AM
> To: Hayeswang
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v2 net-next 6/8] r8169: add a new chip 
> for RTL8111G
> 
> Hayes Wang <hayeswang@realtek.com> :
> > Add a new chip for RTL8111G series.
> 
> It does not need any of the workarounds in patch #5, right ?
 
Excuse me, I don't sure what is your question. Do you mean if the patch "[PATCH
v2 net-next 5/8] r8169: Update the RTL8111G parameters" is necessary before the
current patch? According to the settings from our hw engineers, some settings of
the new chip are the same with the previous 8111g chip using the new parameters.
It would work without patch #5. However, it is necessary to be updated finally,
so I add this patch after patch #5.
 
Best Regards,
Hayes

