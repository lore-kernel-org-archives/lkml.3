Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab3C2IVF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 04:21:05 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:42732 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab3C2IVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 04:21:03 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID r2T8KrA1026335, This message is released by code: ctlocs8528
From: hayeswang <hayeswang@realtek.com>
To: "'Francois Romieu'" <romieu@fr.zoreil.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bowgotsai@google.com>, "'Ryankao'" <ryankao@realtek.com>
References: <4EECA12DD88643FD9006350514D96C8E@realtek.com.tw> <20130328231955.GA26182@electric-eye.fr.zoreil.com> <83FC3118294143DC81063B29EF570FC1@realtek.com.tw> <20130329072056.GA31269@electric-eye.fr.zoreil.com>
Subject: RE: r8169 auto speed down issue
Date: Fri, 29 Mar 2013 16:20:43 +0800
Message-ID: <555174DCA0B0431BB3AE9CCD464E5896@realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: Ac4sTfiJ5RZX7aW3RSm4eGnEiYXTOQAAs4cQ
In-Reply-To: <20130329072056.GA31269@electric-eye.fr.zoreil.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6157
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Francois Romieu [mailto:romieu@fr.zoreil.com] 
> Sent: Friday, March 29, 2013 3:21 PM
> To: Hayeswang
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; 
> bowgotsai@google.com; Ryankao
> Subject: Re: r8169 auto speed down issue
> 
[...]
> 
> I don't get your point. Can you reformulate ?

Sorry for my unclear descriptor. I just think a case that the nic suspends or
shutdowns without cable plugging. Then, the cable is plugged again. If the nic
speed down to 10M and the link partner force 100M, the issue appears again. If
the nic doesn't speed down for normal link partner, it requires more power when
the linking recovers. Finally, I determine to set the speed to 10M when the link
partner supports 10M. And for the other case, setting the speed to 100M. This
avoids the giga nic to keep the speed to 1000M, and could fix this issue.
However, I wonder if there is a switch which forces the speed to giga.

Best Regards,
Hayes

