Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbaBOKlk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 05:41:40 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:38854 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbaBOKlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 05:41:39 -0500
Date: Sat, 15 Feb 2014 13:41:17 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Levente Kurusa <levex@linux.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Micky Ching <micky_ching@realsil.com.cn>,
        OSUOSL Drivers <devel@driverdev.osuosl.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Binderman <dcb314@hotmail.com>
Subject: Re: [PATCH] staging: rts5208: fix always true condition
Message-ID: <20140215104117.GF26722@mwanda>
References: <1392457475-27693-1-git-send-email-levex@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392457475-27693-1-git-send-email-levex@linux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 15, 2014 at 10:44:35AM +0100, Levente Kurusa wrote:
> ANDing anything with 0x1E and expecting it to be not 0x03 will always
> be true. AND instead with 0x03, so that we check the last two bits,
> which should be what was intended there.
> 

This one is less clear what the intent was.  Could easily be that the
0x3 is wrong.

Sometimes it's better to leave the warning rather than guess at the fix.

regards,
dan carpenter

