Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760787Ab3GSPkR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 11:40:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48120 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140Ab3GSPkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 11:40:15 -0400
Date: Fri, 19 Jul 2013 08:40:24 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sven Joachim <svenjoac@gmx.de>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 00/72] 3.10.2-stable review
Message-ID: <20130719154024.GA22704@kroah.com>
References: <20130719052559.852627424@linuxfoundation.org>
 <8761w7dn65.fsf@turtle.gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8761w7dn65.fsf@turtle.gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 09:27:46AM +0200, Sven Joachim wrote:
> On 2013-07-19 07:25 +0200, Greg Kroah-Hartman wrote:
> 
> > This is the start of the stable review cycle for the 3.10.2 release.
> > There are 72 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sun Jul 21 05:25:08 UTC 2013.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.2-rc1.gz
> 
> I've spent just half an hour trying to figure out why this kernel failed
> to install with an incomprehensible error message:
> 
> ,----
> |  BUILDDEB
> | rm: invalid option -- 'c'
> | Try `rm --help' for more information.
> | make[2]: *** [_modinst_] Error 1
> `----
> 
> It turned out that there's a trailing space in the 
> 
> SUBLEVEL = 2 
> 
> line in the Makefile, and that extra space ends up in MODLIB, finally
> passing the 'rm' command _two_ parameters rather than one, the second
> starting with "-rc1".

Very strange, my editor doesn't show me trailing spaces like it used to,
I must have upgraded something recently...

Anyway, sorry about that, I've uploaded a -rc2 version of the patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.2-rc2.gz
that should have solved this issue.

If not, please let me know.

thanks,

greg k-h
