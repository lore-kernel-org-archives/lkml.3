Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329AbaIDOBP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 10:01:15 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:40845 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753275AbaIDOBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 10:01:13 -0400
X-Sasl-enc: cNIckET8W2K05Dk2z9mwmHzkHEj2VQsOQVyiklszxJph 1409839272
Date: Thu, 4 Sep 2014 07:01:11 -0700
From: Greg KH <greg@kroah.com>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?= 
	<holger.hoffstaette@googlemail.com>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.14 00/88] 3.14.18-stable review
Message-ID: <20140904140111.GD12499@kroah.com>
References: <20140903220515.958924632@linuxfoundation.org>
 <20140903234429.GB27174@kroah.com>
 <pan.2014.09.04.10.44.27@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <pan.2014.09.04.10.44.27@googlemail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 10:44:27AM +0000, Holger Hoffstätte wrote:
> On Wed, 03 Sep 2014 16:44:29 -0700, Greg Kroah-Hartman wrote:
> 
> > On Wed, Sep 03, 2014 at 03:04:34PM -0700, Greg Kroah-Hartman wrote:
> >> This is the start of the stable review cycle for the 3.14.18 release.
> >> There are 88 patches in this series, all will be posted as a response
> >> to this one.  If anyone has any issues with these being applied, please
> >> let me know.
> >> 
> >> Responses should be made by Fri Sep  5 22:04:52 UTC 2014.
> >> Anything received after that time might be too late.
> >> 
> >> The whole patch series can be found in one patch at:
> >> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.14.18-rc1.gz
> >> and the diffstat can be found below.
> > 
> > -rc2 is out to fix some issues:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.14.18-rc2.gz
> 
> Built & running fine on 3 different machines (x86_64), clients & server
> with mix of old and new  HW, all with Gentoo ~amd64 userland;
> no regressions.

Thanks for testing and letting me know.

greg k-h
