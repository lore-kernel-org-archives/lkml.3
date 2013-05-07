Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758477Ab3EGU0C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 16:26:02 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:40328 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706Ab3EGU0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 16:26:00 -0400
X-Greylist: delayed 497 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 May 2013 16:26:00 EDT
Date: Tue, 7 May 2013 23:17:31 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [000/126] 3.6.11.3-stable review
Message-ID: <20130507201731.GJ5634@blackmetal.musicnaut.iki.fi>
References: <20130507035712.909872333@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130507035712.909872333@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, May 06, 2013 at 11:57:12PM -0400, Steven Rostedt wrote:
> This is the start of the stable review cycle for 3.6.11.3 release.
> There are 126 patches in this series, which will be posted as responses
> to this one. If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu May 9 23:54:01.
> Anything received after that time might be too late.

Where is this tree maintained? www.kernel.org only has link to
3.6.11-stable but it says it's EOL, and the last tag is 3.6.11 from 2012.

How can I see what's in 3.6.11.2?

> Aaro Koskinen (1):
>       ARM: 7692/1: iop3xx: move IOP3XX_PERIPHERAL_VIRT_BASE
>          [f5d6a1441a5045824f36ff7c6b6bbae0373472a6]

This patch is probably not needed in 3.6.x.y but it probably won't do
any harm either...

A.
