Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932885Ab3CRVTh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:19:37 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:49075 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159Ab3CRVTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:19:30 -0400
Date: Mon, 18 Mar 2013 14:20:46 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [ 29/75] perf,x86: fix kernel crash with PEBS/BTS after
 suspend/resume
Message-ID: <20130318212046.GA13813@kroah.com>
References: <20130318210510.203500214@linuxfoundation.org>
 <20130318210512.334023372@linuxfoundation.org>
 <CABPqkBQquwGc6S3Jfz1tgm2SZhA3pFuSC8xvAojLFk-6G3gqAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBQquwGc6S3Jfz1tgm2SZhA3pFuSC8xvAojLFk-6G3gqAA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 10:11:28PM +0100, Stephane Eranian wrote:
> On Mon, Mar 18, 2013 at 10:06 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > 3.8-stable review patch.  If anyone has any objections, please let me know.
> >
> Greg, you also need to pick David Rientjes patch to fix compilation on
> non X86 architectures.

What git commit id would that be?  I thought I picked up everything that
was needed after this one went in, what did I miss?

thanks,

greg k-h
