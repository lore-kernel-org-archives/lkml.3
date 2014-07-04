Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759433AbaGDRlJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 13:41:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55736 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559AbaGDRlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 13:41:08 -0400
Date: Fri, 4 Jul 2014 10:40:51 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: pramod gurav <pramod.gurav.etc@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Driver core fixes for 3.16-rc4
Message-ID: <20140704174051.GE25992@kroah.com>
References: <20140704010045.GA21040@kroah.com>
 <CAMf-jSnFqUcyCNOa-UecW3SwmVr45Nvo2Qj3DKDu2-CnPgv2pw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMf-jSnFqUcyCNOa-UecW3SwmVr45Nvo2Qj3DKDu2-CnPgv2pw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2014 at 11:52:16AM +0530, pramod gurav wrote:
> On Fri, Jul 4, 2014 at 6:30 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > The following changes since commit 4c834452aad01531db949414f94f817a86348d59:
> >
> >   Linux 3.16-rc3 (2014-06-29 14:11:36 -0700)
> >
> > are available in the git repository at:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git/ tags/driver-core-3.16-rc4
> >
> > for you to fetch changes up to 4a3a99045177369700c60d074c0e525e8093b0fc:
> >
> >   lz4: add overrun checks to lz4_uncompress_unknownoutputsize() (2014-07-03 16:12:04 -0700)
> >
> > ----------------------------------------------------------------
> > Driver core fixes for 3.16-rc4
> 
> Hi Greg,
> 
> What should I do if I come across some coding guidelines issues,
> compile warning in some core drivers like fs/, cpuidle etc?
> 
> For exa: A fix in CPUIdle
> https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg668109.html
> 
> Shall I continue sending the corrections?  Will they be accepted at
> this point of time? Because I saw no response as a lot of code was
> being added to these drivers (read cpuidle).

It all depends on the maintainers of those drivers / files, please
discuss it with them, I have no control over that.

best of luck,

greg k-h
