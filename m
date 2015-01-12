Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbbALSil (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:38:41 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:52612 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970AbbALSik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:38:40 -0500
Date: Mon, 12 Jan 2015 10:38:31 -0800
From: Darren Hart <dvhart@infradead.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Andy Lutomirski <luto@mit.edu>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] platform-drivers-x86 for 3.19
Message-ID: <20150112183831.GA99900@vmdeb7>
References: <20141218175126.GA78864@vmdeb7>
 <20150111225802.GA12944@node.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150111225802.GA12944@node.dhcp.inet.fi>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 12:58:02AM +0200, Kirill A. Shutemov wrote:
> On Thu, Dec 18, 2014 at 09:51:27AM -0800, Darren Hart wrote:
> > thinkpad-acpi using software mute simplifies the driver and the user experience
> > significantly.
> 
> Except when it doesn't.
> 
> I'm probably in minority, but I don't use fancy userspace to mess with my
> mixer and the mute button worked just fine for me before the change.
> Wasted half an hour to find out what happened is not a pure win from user
> experience point of view.
> 
> Is it really necessary to have software_mute_requested == true by default?
> Can fancy userspace ask for desired behaviour instead and change kernel to
> not send hotkeys change notification until software_mute is enabled?
> 
> -- 
>  Kirill A. Shutemov
> 

Thanks for the report Kirill,

Andy, we're at RC4, so if we need to fix (or revert) this fix, we only have a
couple weeks to do so.

Kirill, to define the scope of the problem, if you specify
software_mute_requested as false on the kernel command line, does your system
function as expected?

Thanks,

-- 
Darren Hart
Intel Open Source Technology Center
