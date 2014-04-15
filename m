Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428AbaDOEuh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 00:50:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55457 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115AbaDOEue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 00:50:34 -0400
Date: Mon, 14 Apr 2014 21:53:34 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Jean Delvare <jdelvare@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>
Subject: Re: Hardware dependencies in Kconfig
Message-ID: <20140415045334.GB32541@kroah.com>
References: <20140414145359.48b7337c@endymion.delvare>
 <20140414191143.GA26864@kroah.com>
 <CA+5PVA6tO=mf5iEbuHp9Pqdf+0N7+yxY_AE2Q4GMy+sr9U25jw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA6tO=mf5iEbuHp9Pqdf+0N7+yxY_AE2Q4GMy+sr9U25jw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 03:59:11PM -0400, Josh Boyer wrote:
> 
> Maybe I'm overly grumpy.  Still, it's frustrating to see Kconfig
> entries that clearly say "blahblah found on foo ARM chip" in the help
> with no "depends on ARM" (not meaning to pick on ARM).  I would like
> to think there is some balance that could be found here.

Yes, that would make me grumpy, perhaps a few developers could be
auditing the new Kconfig items of every kernel around -rc3 timeframe to
ensure that they don't do stuff like this...

thanks,

greg k-h
