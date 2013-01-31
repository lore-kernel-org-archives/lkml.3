Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094Ab3AaKfe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 05:35:34 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:45436 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542Ab3AaKfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 05:35:30 -0500
X-Greylist: delayed 513 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Jan 2013 05:35:30 EST
Date: Thu, 31 Jan 2013 11:26:53 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: MIPS atomic_set_mask and atomic_clear_mask
Message-ID: <20130131102653.GA17834@linux-mips.org>
References: <20130131034320.GA15216@gentoo.L3L6.loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130131034320.GA15216@gentoo.L3L6.loongson.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 11:43:21AM +0800, yili0568@gmail.com wrote:

> Hello, everybody:
>      Does MIPS need the functions atomic_set_mask and atomic_clear_mask?
>      Or how can I implement these functions.

No, it doesn't need them.  a quick grep would have shown that all users
are either other architectures or architecture-specific code.

As for a possible implementation, there are plenty of examples in
<asm/bitops.h> and <asm/atomic.h> that would need only minor modification.

  Ralf
