Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759354AbaIPADM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 20:03:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57771 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754985AbaIPADK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 20:03:10 -0400
Date: Mon, 15 Sep 2014 17:03:09 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Kamal Mostafa <kamal@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Subject: Re: [3.13.y.z extended stable] Linux 3.13.11.7 stable review
Message-ID: <20140916000309.GA8853@kroah.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 03:06:50PM -0700, Kamal Mostafa wrote:
> This is the start of the review cycle for the Linux 3.13.11.7 stable kernel.
> 
> This version contains 187 new patches, summarized below.  The new patches are
> posted as replies to this message and also available in this git branch:
> 
> http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=linux-3.13.y-review;a=shortlog
> 
> git://kernel.ubuntu.com/ubuntu/linux.git  linux-3.13.y-review
> 
> The review period for version 3.13.11.7 will be open for the next three days.
> To report a problem, please reply to the relevant follow-up patch message.

As I asked before, please change the name to not be x.y, it is confusing
for lots of people.

Use the "normal" way of naming kernel releases, pick a few character
naming scheme please.

thanks,

greg k-h
