Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123AbaLTRM0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 12:12:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49552 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbaLTRMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 12:12:23 -0500
Date: Sat, 20 Dec 2014 09:12:16 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Robert N <robert.nachlinger@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Robert Nachlinger <robert.nachlinger@googlemail.com>
Subject: Re: [PATCH] Staging: gdm724x: fix space before comma coding style
 issue in gdm_mux.c
Message-ID: <20141220171216.GA24340@kroah.com>
References: <1418921189-31372-1-git-send-email-robert.nachlinger@googlemail.com>
 <20141219225832.GA24045@kroah.com>
 <CABdSh179apawgBKm9=2vBaxVBPTemz4SPhDcgf_2kwk7rsn2oA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABdSh179apawgBKm9=2vBaxVBPTemz4SPhDcgf_2kwk7rsn2oA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 20, 2014 at 12:51:00PM +0100, Robert N wrote:
> I already sent you the patch line-wrapped at column 69, so it says:
> 
> > This is a patch to the gdm_mux.c file that fixes a space before comma
> > coding style issue found by the checkpatch.pl tool.
> 
> Do i have to wrap it exactly at column 72? That would break a word:
> 
> > This is a patch to the gdm_mux.c file that fixes a space before comma co
> > ding style issue found by the checkpatch.pl tool.

Of course not, use a "sane" editor that wraps at a word boundry please.

thanks,

greg k-h
