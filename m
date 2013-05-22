Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab3EVAPo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 20:15:44 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54709 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218Ab3EVAPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 20:15:43 -0400
Date: Wed, 22 May 2013 01:14:57 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        plagnioj@jcrosoft.com, nicolas.ferre@atmel.com, linux@maxim.org.za
Subject: Re: [PATCH] ARM: at91: Fix: Change internal SRAM memory type to
	"MT_MEMORY_SO"
Message-ID: <20130522001457.GA18614@n2100.arm.linux.org.uk>
References: <1369011911-21282-1-git-send-email-wenyou.yang@atmel.com> <1369011979-21354-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369011979-21354-1-git-send-email-wenyou.yang@atmel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 20, 2013 at 09:06:19AM +0800, Wenyou Yang wrote:
> Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>

This needs more of a description.  Also, for a single patch, it's silly
to send two mails, the first being a cover which has a little more
information in it about the patch than the patch itself.

You need to explain _why_ you're making this change.  What I want to see
is that you've thought about the implications of this - particularly that
you know that strongly ordered memory does *not* imply any ordering with
any other memory types.

In other words, I want to know that this change is not a bodge but there's
a real reason behind it.
