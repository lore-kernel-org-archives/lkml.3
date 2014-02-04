Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933310AbaBDXeU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 18:34:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58594 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830AbaBDXeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 18:34:19 -0500
Date: Tue, 4 Feb 2014 15:35:25 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.4 00/37] 3.4.79-stable review
Message-ID: <20140204233525.GA4475@kroah.com>
References: <20140204210055.992134150@linuxfoundation.org>
 <20140204215221.GA2127@bender.morinfr.org>
 <20140204221109.GA906@kroah.com>
 <20140204222203.GA6688@bender.morinfr.org>
 <20140204223150.GA2696@kroah.com>
 <52F16E4C.3080207@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F16E4C.3080207@linaro.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 04, 2014 at 02:48:44PM -0800, John Stultz wrote:
> On 02/04/2014 02:31 PM, Greg Kroah-Hartman wrote:
> > On Tue, Feb 04, 2014 at 11:22:05PM +0100, Guillaume Morin wrote:
> >> On 04 Feb 14:11, Greg Kroah-Hartman wrote:
> >>>>> Borislav Petkov <bp@alien8.de>
> >>>>>     rtc-cmos: Add an alarm disable quirk
> >>>> This is just one of the 3 patches posted by John Stultz on
> >>>> http://git.linaro.org/people/john.stultz/linux.git/shortlog/refs/heads/stable/3.4/timefix
> >>> I have no idea what that tree is, nor what I am supposed to do with it.
> >> Ok, sorry. This is all coming from 
> >> http://article.gmane.org/gmane.linux.kernel.stable/77575/
> >>
> >> I assumed you were aware of it because you participated in the thread
> >> and one of the patch mentioned in this message (Borislav's change) is
> >> applied to the 3.4 branch
> > John said he would submit those patches after -rc2 came out, I wasn't
> > aware that this specific patch was part of that series, sorry, should I
> > drop it for now?
> 
> Yea. Hold off on it for now, I'll resubmit it after -rc2.

Now dropped from 3.4, 3.10, 3.12, and 3.13 trees.

thanks,

greg k-h
