Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253AbaBEKw3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 05:52:29 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:52071 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbaBEKw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 05:52:27 -0500
MIME-Version: 1.0
Reply-To: andrea.merello@gmail.com
In-Reply-To: <52F17257.8020303@lwfinger.net>
References: <52ee2ee736e00_2c3211fc86c5851f@209.249.196.67.mail>
 <20140202160512.GA4946@redhat.com> <201402021807.37772.s.L-H@gmx.de>
 <52EFCC66.9020304@lwfinger.net> <20140203201228.GE26722@mwanda>
 <CA+55aFyHZfw9rtZQJ9i2p7MQAVX4iM0QCdzRZzaivD2nRDHeLQ@mail.gmail.com>
 <CAN8YU5PJWqnaBN_oaZ-yZjV-s9oCkKPa4ebk-kNbhPSgpd3_wQ@mail.gmail.com>
 <20140204092836.GG26776@mwanda> <CAN8YU5PfJ2ijHzghJ-FJPYJeFwTfoGN-qpJ5R5ctYp3R1p13hA@mail.gmail.com>
 <52F12A10.3020600@lwfinger.net> <CAN8YU5PzKE-6Y_651hSwwx1p2i682qi3TYibL5Bu0rBFOJv4cw@mail.gmail.com>
 <52F17257.8020303@lwfinger.net>
From: Andrea Merello <andrea.merello@gmail.com>
Date: Wed, 5 Feb 2014 11:52:06 +0100
Message-ID: <CAN8YU5NBSMVJTs=Y8YS7iLv-a8bwhD00OfY42zq6t=8HmZF0hw@mail.gmail.com>
Subject: Re: rtl8821ae.
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stefan Lippers-Hollmann <s.L-H@gmx.de>, Dave Jones <davej@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Driver Project <devel@linuxdriverproject.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Somehow I missed this patch. Do you know if John Linville picked it up?
>

AFAIK no..

> I'm not sure if the ANAPARAM3 register could handle a 16-bit write on an
> RTL8187B. To be cautious, I wrote and have tested the attached patch using a
> union. The patch includes a fix for an undefined symbol
> (RTL818X_TX_CONF_HW_SEQNUM). With this patch my RTL8187SE and RTL8187B
> devices both work.

Excellent, thank you !


> Larry
>
