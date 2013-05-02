Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762101Ab3EBVp7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 17:45:59 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:37597 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab3EBVp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 17:45:58 -0400
Date: Thu, 2 May 2013 23:45:49 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Nobuhiro Iwamatsu <iwamatsu@nigauri.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: kirkwood: add button for OpenBlock A6
Message-ID: <20130502234549.79caecc3@skate>
In-Reply-To: <5182C512.4050102@free-electrons.com>
References: <1367523802-16372-1-git-send-email-gregory.clement@free-electrons.com>
	<5182C512.4050102@free-electrons.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Gregory CLEMENT,

On Thu, 02 May 2013 21:57:06 +0200, Gregory CLEMENT wrote:

> Oh, I found that Thomas have already submitted the same patch but I
> was misleaded because I didn't find anything related to this in v3.9,
> nor in next-20130502.
> 
> You can drop this patch of course, but waht happens to Thomas' patch?

I have to rework it as part as a refactoring of the pinctrl definitions
on kirkwood. I'll try to work on that soon.

Thanks,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
