Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759018Ab3EGU2v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 16:28:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17647 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756807Ab3EGU2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 16:28:48 -0400
X-Authority-Analysis: v=2.0 cv=UY7TuduN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=eIhxMilvRf8A:10 a=P6b63XBnyJwA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=zNXoGfytzK0A:10 a=VwQbUJbxAAAA:8 a=WPXX39bUDmeotTDIzQUA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1367958526.7373.58.camel@gandalf.local.home>
Subject: Re: [000/126] 3.6.11.3-stable review
From: Steven Rostedt <rostedt@goodmis.org>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Tue, 07 May 2013 16:28:46 -0400
In-Reply-To: <20130507201731.GJ5634@blackmetal.musicnaut.iki.fi>
References: <20130507035712.909872333@goodmis.org>
	 <20130507201731.GJ5634@blackmetal.musicnaut.iki.fi>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-05-07 at 23:17 +0300, Aaro Koskinen wrote:
> Hello,
> 
> On Mon, May 06, 2013 at 11:57:12PM -0400, Steven Rostedt wrote:
> > This is the start of the stable review cycle for 3.6.11.3 release.
> > There are 126 patches in this series, which will be posted as responses
> > to this one. If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu May 9 23:54:01.
> > Anything received after that time might be too late.
> 
> Where is this tree maintained? www.kernel.org only has link to
> 3.6.11-stable but it says it's EOL, and the last tag is 3.6.11 from 2012.

It's part of the -rt releases. I'm only doing this temporally until
3.8-rt is stable.

> 
> How can I see what's in 3.6.11.2?

The git tree is at:

 git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

branch: v3.6-stable

As well as the patches at:

http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/stable/patch-3.6.11.2.xz

I don't push up review patches until final. Although I might start
storing -rc patches in the near future.

> 
> > Aaro Koskinen (1):
> >       ARM: 7692/1: iop3xx: move IOP3XX_PERIPHERAL_VIRT_BASE
> >          [f5d6a1441a5045824f36ff7c6b6bbae0373472a6]
> 
> This patch is probably not needed in 3.6.x.y but it probably won't do
> any harm either...

OK, I'll keep it then.

Thanks,

-- Steve


