Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab3C2CMH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 22:12:07 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:47240 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754831Ab3C2CMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 22:12:06 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID r2T2BsbE000566, This message is released by code: ctlocs8528
From: hayeswang <hayeswang@realtek.com>
To: "'Francois Romieu'" <romieu@fr.zoreil.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bowgotsai@google.com>, "'Ryankao'" <ryankao@realtek.com>
References: <4EECA12DD88643FD9006350514D96C8E@realtek.com.tw> <20130328231955.GA26182@electric-eye.fr.zoreil.com>
Subject: RE: r8169 auto speed down issue
Date: Fri, 29 Mar 2013 10:11:57 +0800
Message-ID: <83FC3118294143DC81063B29EF570FC1@realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: Ac4sCsd4+vmv0ptDQ7qGiaSRAdgXngAF0csg
In-Reply-To: <20130328231955.GA26182@electric-eye.fr.zoreil.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6157
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Francois Romieu [mailto:romieu@fr.zoreil.com] 
[...]
> Your description suggests that testing against the link 
> partner ability
> to work at 10M instead of testing for tp->link_ok could be 
> good enough.
> 
> Does it make sense ?
> 

Furthermore, should it not speed down without linking, even though the cable
would be plugged after suspending or shutdowning?

Best Regards,
Hayes

