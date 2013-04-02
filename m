Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759970Ab3DBCjf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 22:39:35 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:33216 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759806Ab3DBCje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 22:39:34 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID r322dRYm023592, This message is released by code: ctlocs8528
From: hayeswang <hayeswang@realtek.com>
To: "'Francois Romieu'" <romieu@fr.zoreil.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1364824539-4156-1-git-send-email-hayeswang@realtek.com> <1364824539-4156-5-git-send-email-hayeswang@realtek.com> <20130401222235.GB19335@electric-eye.fr.zoreil.com>
Subject: RE: [PATCH net-next 5/7] r8169: add a new chip for RTL8111G
Date: Tue, 2 Apr 2013 10:39:31 +0800
Message-ID: <2808A1ABA9A5470C8CB9534309588984@realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: Ac4vJ2u41mrrZaqqRu+TrbCu3ovk2AAIr3kg
In-Reply-To: <20130401222235.GB19335@electric-eye.fr.zoreil.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6157
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Francois Romieu [mailto:romieu@fr.zoreil.com] 
> Sent: Tuesday, April 02, 2013 6:23 AM
> To: Hayeswang
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH net-next 5/7] r8169: add a new chip for RTL8111G
> 
[..]
> There is close to zero added value for this stuff in the kernel.
> You may as well move it completely into the firmware.

Do you mean all of the phy settings? I have checked these settings with our hw
engineers. These are not firmware. 

Best Regards,
Hayes

