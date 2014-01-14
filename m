Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998AbaANTwS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 14:52:18 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:21160 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbaANTwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 14:52:14 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+yw5VZOoCQFKfd1/1Ag4KWJ/QysKPgBbQ=
X-DKIM: OpenDKIM Filter v2.0.1 titan 8C3AF50A109
Date: Tue, 14 Jan 2014 14:52:12 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: bjoern <lkml@call-home.ch>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel above 3.8 prevents booting Linux
Message-ID: <20140114195212.GT19878@titan.lakedaemon.net>
References: <20140114203210.76eeed0d@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140114203210.76eeed0d@ubuntu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bjoern,

On Tue, Jan 14, 2014 at 08:32:10PM +0100, bjoern wrote:
> I have an Ubuntu 12.04 x64 server. The hard disk is encrypted using LVM.
> 
> With kernel 3.8.8, the server works fine - I am asked to enter the
> password and can boot the system.
> 
> Any kernel above 3.8, e.g. 3.9/3.11 (I didn't try many) prevents me from
> entering the password. It seems the attached USB keyboard is no longer
> being read from or the system is hanging.

Have you tried adding the usb keyboard module to
/etc/initramfs-tools/modules and rebuilding your initrds?

hth,

Jason.
