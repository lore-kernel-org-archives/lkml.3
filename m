Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806Ab3CPUr1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 16:47:27 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:61799 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751482Ab3CPUr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 16:47:26 -0400
Message-ID: <1363466844.1335.133.camel@x61.thuisdomein>
Subject: Re: RAMster selects HAVE_ALIGNED_STRUCT_PAGE on 64 bit systems when
 it should not
From: Paul Bolle <pebolle@tiscali.nl>
To: Martin Walch <walch.martin@web.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Sat, 16 Mar 2013 21:47:24 +0100
In-Reply-To: <1577953.rJTZvHtihu@tacticalops>
References: <1577953.rJTZvHtihu@tacticalops>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Mar 2013 20:47:25.0163 (UTC) FILETIME=[76EF0BB0:01CE2287]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-03-16 at 20:35 +0100, Martin Walch wrote:
> 64_BIT should probably say 64BIT which has corresponding config sections in 
> arch/{x86,ia64,mips,s390,tile,alpha,arm64,sparc,parisc,powerpc}/Kconfig and 
> arch/x86/um/Kconfig.
> 
> I do not know if there are any bad consequences about this, but I guess this 
> should be reviewed and fixed, probably by just removing the underscore from 
> 64_BIT in drivers/staging/zcache/Kconfig.

It's an obvious typo. See the patch I sent last week:
https://lkml.org/lkml/2013/3/9/106 . I have not yet received any
feedback.


Paul Bolle

