Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616AbaGGTOf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 15:14:35 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:64613 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbaGGTOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 15:14:34 -0400
Date: Mon, 7 Jul 2014 12:14:30 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Manuel Reimer <Manuel.Spam@nurfuerspam.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 3.15.4 runs *significantly* slower than 3.15.3 on iMX233 CPU
Message-ID: <20140707191430.GA23004@roeck-us.net>
References: <lpeofi$1fl$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <lpeofi$1fl$1@ger.gmane.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2014 at 08:21:38PM +0200, Manuel Reimer wrote:
> Hello,
> 
> maybe someone can help me to find the reason for this problem:
> 
> If I run my iMX233 development board with an 3.15.3 kernel, then the
> performance is much better as with an 3.15.4 kernel.
> 
> I have the first significant "hanging" here:
> 
> [    7.910000] sd 0:0:0:0: [sda] Attached SCSI removable disk
> [   10.810000] random: nonblocking pool is initialized
> [   24.310000] systemd[1]: systemd 214 running in system mode. (+PAM
> -AUDIT -SELINUX -IMA -SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ
> +SECCOMP -APPARMOR)
> 
> After booting up it takes several seconds between entering the
> username and the password while with version 3.15.3 the password
> prompt appears almost immediately after entering the username.
> 

Are you sure this did not just happen when you booted the new kernel
for the first time ? I have seen similar behavior with some distributions.

If it happens all the time, ie at subsequent boots as wel, you'll probably
have to bisect the problem. I have not seen an obvious culprit.

Guenter
