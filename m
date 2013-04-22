Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357Ab3DVCY1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 22:24:27 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:49585 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904Ab3DVCYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 22:24:23 -0400
X-AuditID: 9c930179-b7b5bae0000069d1-a8-51749f52cfc9
From: "Jongsung Kim" <neidhard.kim@lge.com>
To: "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>
Cc: <gregkh@linuxfoundation.org>, <jslaby@suse.cz>,
        <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <201304151445.25151.neidhard.kim@lge.com> <20130419141748.GU14496@n2100.arm.linux.org.uk>
In-Reply-To: <20130419141748.GU14496@n2100.arm.linux.org.uk>
Subject: RE: [RESEND][PATCH] ARM: PL011: add support for extended FIFO-size	of PL011-r1p5
Date: Mon, 22 Apr 2013 11:24:18 +0900
Message-ID: <019701ce3f00$7e0c5390$7a24fab0$@lge.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQJA+uJt7DT2d3XFxKZdxbxc1LBiMwIysIM1l+pvhhA=
Content-Language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for your comments, Russell. I'll happily apply your recommendation
just after it come up to the merge window. Or, do you want me to send it by now?

-----Original Message-----
From: Russell King - ARM Linux [mailto:linux@arm.linux.org.uk] 
Sent: Friday, April 19, 2013 11:18 PM
To: Jongsung Kim
Cc: gregkh@linuxfoundation.org; jslaby@suse.cz; linux-serial@vger.kernel.org;
linux-kernel@vger.kernel.org
Subject: Re: [RESEND][PATCH] ARM: PL011: add support for extended FIFO-size of
PL011-r1p5

On Mon, Apr 15, 2013 at 02:45:25PM +0900, Jongsung Kim wrote:
> The latest r1p5-revision of the ARM PL011 UART has 32-byte FIFOs,
> while all earlier ones have 16-byte FIFOs. This patch suggests
> a way to set the FIFO-size correctly & flexibly by using a member
> function named get_fifosize, rather than using the fifosize member
> variable. The function takes the UARTPeriphID, and returns the
> correct FIFO size.

Same comments as previous version.

