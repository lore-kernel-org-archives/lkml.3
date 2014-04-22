Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105AbaDVKfb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 06:35:31 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:46456 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754967AbaDVKfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 06:35:30 -0400
Date: Tue, 22 Apr 2014 13:35:10 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: navin patidar <navin.patidar@gmail.com>
Cc: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/10] staging: rtl8188eu: Remove unused enum
 LED_STATE_871x members.
Message-ID: <20140422103510.GI26890@mwanda>
References: <1397983638-10752-1-git-send-email-navin.patidar@gmail.com>
 <1397983638-10752-9-git-send-email-navin.patidar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397983638-10752-9-git-send-email-navin.patidar@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's ok to renumber all of these?  It's not something the firmware will
care about?  Have you tested this?  Same for patch 10/10.

(These questions are just questions.  I don't ask rhetorical questions
on email.  I don't know the answers).

regards,
dan carpenter

