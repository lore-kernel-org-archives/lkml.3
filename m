Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915AbaCKXIM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 19:08:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46129 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755496AbaCKXIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 19:08:10 -0400
Date: Tue, 11 Mar 2014 16:08:57 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Chris Cheng <chris.cheng@atrustcorp.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Andreas Noever <andreas.noever@gmail.com>
Subject: Re: [PATCH 3.4 30/99] PCI: Enable INTx if BIOS left them disabled
Message-ID: <20140311230857.GB7626@kroah.com>
References: <20140308010611.468206150@linuxfoundation.org>
 <20140308010612.589034591@linuxfoundation.org>
 <CAErSpo6r0P=z0sT-+qKvjZOpa7aHv3E94-t7mvXzSps96fWf9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo6r0P=z0sT-+qKvjZOpa7aHv3E94-t7mvXzSps96fWf9Q@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 08, 2014 at 06:50:30AM -0700, Bjorn Helgaas wrote:
> [+cc Andreas]
> 
> On Fri, Mar 7, 2014 at 6:07 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > 3.4-stable review patch.  If anyone has any objections, please let me know.
> 
> Let's hold off on this for a bit.  Andreas found that this patch
> breaks pciehp, and we haven't figured out the best fix yet.
> 
> http://lkml.kernel.org/r/CAMxnaaXd9-VbxSYa9q1YVT+fwfDFYKGG2Hq-1jkc-awLX-HwtQ@mail.gmail.com
> https://bugzilla.kernel.org/show_bug.cgi?id=71691

Thanks for letting me know, now dropped.

greg k-h
