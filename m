Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762731Ab3JQVFF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 17:05:05 -0400
Received: from gw03.mail.saunalahti.fi ([195.197.172.111]:48426 "EHLO
	gw03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758386Ab3JQVFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 17:05:04 -0400
X-Greylist: delayed 632 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Oct 2013 17:05:04 EDT
Date: Thu, 17 Oct 2013 23:54:28 +0300 (EEST)
From: Joonas Saarinen <jza@saunalahti.fi>
To: linux-kernel@vger.kernel.org
Message-ID: <17862115.9387961382043268695.JavaMail.jza@saunalahti.fi>
Subject: Re: AMD Bobcat cpufreq
MIME-Version: 1.0
Content-Type: text/plain; Charset=iso-8859-1; Format=Flowed
Content-Transfer-Encoding: 7bit
X-Mailer: Saunalahti webmail - http://saunalahti.fi
X-Originating-IP: 80.223.182.224
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Aug 2013 13:17:53 +0200 Borislav Petkov wrote:
> On Tue, Aug 20, 2013 at 10:58:07PM +0300, Joonas Saarinen wrote:
> > Hi guys,
> > 
> > The turbo core feature on AMD Bobcat platform seems not to be
> > working. I have a netbook with C-60 CPU which never cranks the
> > frequency over 1000MHz (it could reach 1333MHz).
>
> Yeah, how about more info like which kernel, /proc/cpuinfo, full
> dmesg, dmidecode... sounds like enough for starters.
>
> Thanks.

All right. I'm finally back to re-investigate the issue. The
requested data can be found at:

http://users.metropolia.fi/~joonasms/bobcat/

The CPU underclocks as expected but the turbo multiplier is never
activated.

Joonas

