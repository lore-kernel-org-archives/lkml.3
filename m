Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138Ab3LOXMM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 18:12:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36728 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab3LOXML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 18:12:11 -0500
Date: Sun, 15 Dec 2013 15:14:13 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: BUG: key ffff8800192a6ad0 not in .data!
Message-ID: <20131215231413.GA6853@kroah.com>
References: <20131215063123.GB26396@localhost>
 <20131215170417.GB28799@kroah.com>
 <CAErSpo4Usujp5zJT83-88T71J8tObJgZ03i-wORqLputxQbdXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo4Usujp5zJT83-88T71J8tObJgZ03i-wORqLputxQbdXg@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 15, 2013 at 03:12:03PM -0700, Bjorn Helgaas wrote:
> On Sun, Dec 15, 2013 at 10:04 AM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Sun, Dec 15, 2013 at 02:31:23PM +0800, Fengguang Wu wrote:
> >> Greetings,
> >>
> >> I got the below dmesg and the first bad commit is
> >
> > I thought this was already fixed in Bjorn's tree, but perhaps he hasn't
> > merged in the one-liner for it...
> 
> Yes, this is fixed.  I actually dropped that MSI change temporarily
> until we can fold in the memory leak fixes, so it is not currently in
> linux-next.

Do you want me to just resend a fixed patch up with the one-line fix,
and the memory-leak-on-error-path fix all as just one patch to make it
easier for you?

thanks,

greg k-h
