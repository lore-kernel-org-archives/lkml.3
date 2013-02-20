Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935487Ab3BTCvJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 21:51:09 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:52122 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934740Ab3BTCvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 21:51:05 -0500
Date: Tue, 19 Feb 2013 18:51:30 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <shuahkhan@gmail.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 0/1] 3.4.33-stable review
Message-ID: <20130220025130.GA32589@kroah.com>
References: <20130218181454.615592566@linuxfoundation.org>
 <CAKocOOPShXASvWEJw7r_NxTAKYA34DH9BiaEKo0saWEobar9zQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKocOOPShXASvWEJw7r_NxTAKYA34DH9BiaEKo0saWEobar9zQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2013 at 07:50:16PM -0700, Shuah Khan wrote:
> On Mon, Feb 18, 2013 at 11:24 AM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > This is the start of the stable review cycle for the 3.4.33 release.
> > There is 1 patch in this series, which will be posted as a response to
> > this one.  If anyone has any issues with it being applied, please let me
> > know.
> >
> > Responses should be made by Wed Feb 20 18:13:44 UTC 2013.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.33-rc1.gz
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
> > -------------
> 
> Patches applied cleanly to 3.0.65, and 3.4.32
> Compiled and booted on the following systems:
> HP EliteBook 6930p Intel(R) Core(TM)2 Duo CPU T9400 @ 2.53GHz
> HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics
> 
> Reviewed patches
> 
> Skipped Cross-compile tests

Thanks for testing, your kernel log messages looked correct, right?

greg k-h
