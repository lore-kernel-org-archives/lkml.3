Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090Ab3GKRIP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 13:08:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38793 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab3GKRIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 13:08:14 -0400
Date: Thu, 11 Jul 2013 10:08:13 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Oliver Schinagl <oliver+list@schinagl.nl>
Cc: linux-kernel@vger.kernel.org, linux@roeck-us.net, khali@linux-fr.org
Subject: Re: [PATCH v2 2/7] sysfs.h: add ATTRIBUTE_GROUPS() macro
Message-ID: <20130711170813.GD23056@kroah.com>
References: <1373486714-14531-1-git-send-email-gregkh@linuxfoundation.org>
 <1373502965-1683-1-git-send-email-gregkh@linuxfoundation.org>
 <1373502965-1683-3-git-send-email-gregkh@linuxfoundation.org>
 <51DE9F16.3090405@schinagl.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51DE9F16.3090405@schinagl.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 02:03:34PM +0200, Oliver Schinagl wrote:
> On 11-07-13 02:36, Greg Kroah-Hartman wrote:
> >To make it easier for driver subsystems to work with attribute groups,
> >create the ATTRIBUTE_GROUPS macro to remove some of the repetitive
> >typing for the most common use for attribute groups.
> Forgot to add this trivial little cleanup patch with my previous
> mail, I know you don't like patch dependancies, but this one depends
> on the previous one as that included stat.h, if you decide my
> previous patch isn't good, i can redo this one with stat.h included
> (and move atomic.h to the top to keep includes alphabetically
> ordered).

No problem, I can merge this with your other one when I can figure out
what that one is really doing :)

thanks,

greg k-h
