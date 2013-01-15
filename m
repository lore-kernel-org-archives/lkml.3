Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750912Ab3AOFEy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 00:04:54 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:55033 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab3AOFEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 00:04:54 -0500
Message-ID: <1358226315.5576.3.camel@gitbox>
Subject: Re: [PATCH 2/4] serial: vt8500: ioremap'd resource is never freed
From: Tony Prisk <linux@prisktech.co.nz>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: vt8500-wm8505-linux-kernel@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk
Date: Tue, 15 Jan 2013 18:05:15 +1300
In-Reply-To: <1358225886-5686-3-git-send-email-linux@prisktech.co.nz>
References: <1358225886-5686-1-git-send-email-linux@prisktech.co.nz>
	 <1358225886-5686-3-git-send-email-linux@prisktech.co.nz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-15 at 17:58 +1300, Tony Prisk wrote:
> Memory mapped via ioremap call is never released. Rather than add an
> iounmap call, change allocation function to devm_request_and_ioremap.
> 
> Also, change the error on failure for this call to -EBUSY rather than
> -EADDRNOTAVAIL.

Grr.. I thought I fixed this typo before I sent the patch.
I'll send another version but I'll wait for feedback on the series
first.

Regards
Tony P

