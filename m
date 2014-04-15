Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbaDOH1p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 03:27:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48261 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbaDOH1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 03:27:43 -0400
Date: Tue, 15 Apr 2014 09:27:39 +0200
From: Jean Delvare <jdelvare@suse.de>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Josh Boyer <jwboyer@fedoraproject.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>
Subject: Re: Hardware dependencies in Kconfig
Message-ID: <20140415092739.7f1c1ddd@endymion.delvare>
In-Reply-To: <20140415045334.GB32541@kroah.com>
References: <20140414145359.48b7337c@endymion.delvare>
	<20140414191143.GA26864@kroah.com>
	<CA+5PVA6tO=mf5iEbuHp9Pqdf+0N7+yxY_AE2Q4GMy+sr9U25jw@mail.gmail.com>
	<20140415045334.GB32541@kroah.com>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Mon, 14 Apr 2014 21:53:34 -0700, Greg KH wrote:
> On Mon, Apr 14, 2014 at 03:59:11PM -0400, Josh Boyer wrote:
> > 
> > Maybe I'm overly grumpy.  Still, it's frustrating to see Kconfig
> > entries that clearly say "blahblah found on foo ARM chip" in the help
> > with no "depends on ARM" (not meaning to pick on ARM).  I would like
> > to think there is some balance that could be found here.
> 
> Yes, that would make me grumpy, perhaps a few developers could be
> auditing the new Kconfig items of every kernel around -rc3 timeframe to
> ensure that they don't do stuff like this...

It's the reviewer's job to refuse new drivers with bad Kconfig
descriptions in the first place. This must happen as early as possible
in the chain. By -rc3 it's way too late, all kernel developers and
distributions have already moved to the new kernel so they have already
answered the n/m/y question for all new entries.

-- 
Jean Delvare
SUSE L3 Support
