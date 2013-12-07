Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758957Ab3LGQ7k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 11:59:40 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:46394 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758884Ab3LGQ7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 11:59:36 -0500
X-Sasl-enc: DBWPZOdFYLHlp3FqR5FnKEezcYT2/92MuuG71QOMixwk 1386435575
Date: Sat, 7 Dec 2013 09:01:04 -0800
From: Greg KH <greg@kroah.com>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?= 
	<holger.hoffstaette@googlemail.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.12 00/83] 3.12.4-stable review
Message-ID: <20131207170104.GB18638@kroah.com>
References: <20131206214640.002320724@linuxfoundation.org>
 <l7tkek$psd$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <l7tkek$psd$1@ger.gmane.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 06, 2013 at 10:52:04PM +0000, Holger Hoffstätte wrote:
> On Fri, 06 Dec 2013 13:50:50 -0800, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.12.4 release.
> 
> Patch applied cleanly on top of 3.12.3. Built & runs with no problems on 
> both a Thinkpad T60 (x86) and two generic whiteboxes (x64, i5/i7).
> No regressions noticed so far.

Thanks for testing.

greg k-h
