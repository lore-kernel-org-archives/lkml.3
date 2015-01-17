Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981AbbAQS7y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 13:59:54 -0500
Received: from senator.holtmann.net ([87.106.208.187]:52221 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbbAQS7w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 13:59:52 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: [PATCH] ath3k: Add support of AR3012 bluetooth 13d3:3423 device
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <54BA1CC9.8060601@gmail.com>
Date: Sat, 17 Jan 2015 10:59:43 -0800
Cc: linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <F80A6947-61FA-46A1-8742-51129F4E18C3@holtmann.org>
References: <54B98679.5060104@gmail.com> <2E4EB7E1-D16C-4633-8E86-337D42190298@holtmann.org> <54BA1CC9.8060601@gmail.com>
To: Dmitry Tunin <hanipouspilot@gmail.com>
X-Mailer: Apple Mail (2.1993)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

please do not top post on this mailing list.

> This patch is against git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git
> Or is it another branch?
> 
> I pulled it again, but still no changes. Why it can be?

it neither applies with git am, nor manually running patch.

checking file drivers/bluetooth/ath3k.c
Hunk #1 FAILED at 108.
Hunk #2 FAILED at 162.
2 out of 2 hunks FAILED
checking file drivers/bluetooth/btusb.c
Hunk #1 FAILED at 189.
1 out of 1 hunk FAILED

Regards

Marcel

