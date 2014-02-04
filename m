Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782AbaBDSAO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 13:00:14 -0500
Received: from mail-ve0-f180.google.com ([209.85.128.180]:41800 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125AbaBDSAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 13:00:12 -0500
MIME-Version: 1.0
In-Reply-To: <CAN8YU5PJWqnaBN_oaZ-yZjV-s9oCkKPa4ebk-kNbhPSgpd3_wQ@mail.gmail.com>
References: <52ee2ee736e00_2c3211fc86c5851f@209.249.196.67.mail>
	<20140202160512.GA4946@redhat.com>
	<201402021807.37772.s.L-H@gmx.de>
	<52EFCC66.9020304@lwfinger.net>
	<20140203201228.GE26722@mwanda>
	<CA+55aFyHZfw9rtZQJ9i2p7MQAVX4iM0QCdzRZzaivD2nRDHeLQ@mail.gmail.com>
	<CAN8YU5PJWqnaBN_oaZ-yZjV-s9oCkKPa4ebk-kNbhPSgpd3_wQ@mail.gmail.com>
Date: Tue, 4 Feb 2014 10:00:11 -0800
X-Google-Sender-Auth: mmQUZK88Xj6zn9tMv9TTsSi0roQ
Message-ID: <CA+55aFyF05NqDrRFnuVmUAwQFQz9k41+exSo1xVz69t_PJakOA@mail.gmail.com>
Subject: Re: rtl8821ae.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrea Merello <andrea.merello@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Stefan Lippers-Hollmann <s.L-H@gmx.de>, Dave Jones <davej@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Driver Project <devel@linuxdriverproject.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 3, 2014 at 6:22 PM, Andrea Merello <andrea.merello@gmail.com> wrote:
> Right now I have merged rtl8187se support in rtl8180 driver. But I must
> admit that I ever been in doubt about whether to produce a separate driver
> rather than going on merging.

If you've already merged them, and you think it works, keep it that way.

I was just saying that merging drivers isn't necessarily always the
right thing to do, and can be painful as hell.

                  Linus
