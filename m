Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711AbaIPB1A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 21:27:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58436 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755319AbaIPB06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 21:26:58 -0400
Date: Mon, 15 Sep 2014 18:26:09 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: Kamal Mostafa <kamal@canonical.com>, kernel-team@lists.ubuntu.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [3.13.y.z extended stable] Linux 3.13.11.7 stable review
Message-ID: <20140916012609.GB29475@kroah.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
 <20140916000309.GA8853@kroah.com>
 <54178FEB.3000606@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54178FEB.3000606@canonical.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 07:18:35PM -0600, Tim Gardner wrote:
> On 09/15/2014 06:03 PM, Greg KH wrote:
> > On Mon, Sep 15, 2014 at 03:06:50PM -0700, Kamal Mostafa wrote:
> >> This is the start of the review cycle for the Linux 3.13.11.7 stable kernel.
> >>
> >> This version contains 187 new patches, summarized below.  The new patches are
> >> posted as replies to this message and also available in this git branch:
> >>
> >> http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=linux-3.13.y-review;a=shortlog
> >>
> >> git://kernel.ubuntu.com/ubuntu/linux.git  linux-3.13.y-review
> >>
> >> The review period for version 3.13.11.7 will be open for the next three days.
> >> To report a problem, please reply to the relevant follow-up patch message.
> > 
> > As I asked before, please change the name to not be x.y, it is confusing
> > for lots of people.
> > 
> > Use the "normal" way of naming kernel releases, pick a few character
> > naming scheme please.
> > 
> 
> I think what Kamal said is that he would consider your request. I,
> however, don't think it wise to change version schemes mid-stream in an
> established series.

Even if that "established series" is the thing that is causing
complaints?

> Can you provide hard evidence that this version scheme is confusing lots
> of people ? I'm only aware of one complaint voiced by Peter Anvin at the
> kernel summit (http://lwn.net/Articles/608917/).

Peter's complaint is one that I know of that is in the public record.

So is mine.

How many others do you need?

thanks,

greg k-h
