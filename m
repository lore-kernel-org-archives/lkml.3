Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758157Ab3APECv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 23:02:51 -0500
Received: from mail.kernel.org ([198.145.19.201]:60780 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757153Ab3APECu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 23:02:50 -0500
Date: Tue, 15 Jan 2013 20:03:48 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <shuahkhan@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [ 000/171] 3.4.26-stable review
Message-ID: <20130116040348.GA12335@kroah.com>
References: <20130115224313.394976595@linuxfoundation.org>
 <CAKocOOOVoViOdViChm58ZGM6M6FCkq5VUDZjfDvjBqF7PSoQnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKocOOOVoViOdViChm58ZGM6M6FCkq5VUDZjfDvjBqF7PSoQnQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 08:48:24PM -0700, Shuah Khan wrote:
> On Tue, Jan 15, 2013 at 3:42 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > This is the start of the stable review cycle for the 3.4.26 release.
> > There are 171 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu Jan 17 22:42:47 UTC 2013.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.26-rc1.gz
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Patches applied cleanly to 3.0.y, 3.4.y, and 3.7.y.
> Compiled and booted on the following systems:
> HP EliteBook 6930p Intel(R) Core(TM)2 Duo CPU T9400 @ 2.53GHz
> HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics

Thanks for testing.

greg k-h
