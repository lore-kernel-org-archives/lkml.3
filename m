Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551AbaEaOYX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 10:24:23 -0400
Received: from gproxy4-pub.mail.unifiedlayer.com ([69.89.23.142]:55372 "HELO
	gproxy4-pub.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756394AbaEaOYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 10:24:21 -0400
X-Authority-Analysis: v=2.1 cv=CpMsLBID c=1 sm=1 tr=0
 a=yEjhGPV9XlbPNRGz7jjbow==:117 a=yEjhGPV9XlbPNRGz7jjbow==:17 a=DsvgjBjRAAAA:8
 a=f5113yIGAAAA:8 a=ejg-4CzlklgA:10 a=neHJxMmKCwgA:10 a=IkcTkHD0fZMA:10
 a=wCmvBT1CAAAA:8 a=djd9j7hWnewA:10 a=3mQisGbx5lUA:10 a=vWLUUH5Xqd-yPiJf6e0A:9
 a=QEXdDO2ut3YA:10
Message-ID: <1401546229.2413.2.camel@slavad-CELSIUS-H720>
Subject: Re: [RFC 24/32] hfs, hfsplus: convert to struct inode_time
From: Vyacheslav Dubeyko <slava@dubeyko.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        joseph@codesourcery.com, john.stultz@linaro.org, hch@infradead.org,
        tglx@linutronix.de, geert@linux-m68k.org, lftan@altera.com,
        hpa@zytor.com, linux-fsdevel@vger.kernel.org
Date: Sat, 31 May 2014 18:23:49 +0400
In-Reply-To: <1401480116-1973111-25-git-send-email-arnd@arndb.de>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
	 <1401480116-1973111-25-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Identified-User: {2172:host202.hostmonster.com:dubeykoc:dubeyko.com} {sentby:smtp auth 46.39.244.124 authed with slava@dubeyko.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Fri, 2014-05-30 at 22:01 +0200, Arnd Bergmann wrote:
> hfs uses 32-bit integers based at 1904 for inode timestamps, which will
> only work until 2040, but the VFS uses struct timespec for timestamps,
> which expires even earlier in 2038 on 32-bit CPUs.
> 
> This gets us one small step closer to lifting the VFS limit by using
> struct inode_time in logfs.
> 

I think you meant hfs/hfsplus here. I suppose that mentioning the logfs
is simple misspelling.

Thanks,
Vyacheslav Dubeyko.


