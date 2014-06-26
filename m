Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633AbaFZTKF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 15:10:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58737 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbaFZTKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 15:10:02 -0400
Date: Thu, 26 Jun 2014 15:09:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.15 00/61] 3.15.2-stable review
Message-ID: <20140626190945.GC5565@kroah.com>
References: <20140624154952.751713761@linuxfoundation.org>
 <20140625142043.GP23137@kvack.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140625142043.GP23137@kvack.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 10:20:43AM -0400, Benjamin LaHaise wrote:
> Hi Greg,
> 
> On Tue, Jun 24, 2014 at 11:50:43AM -0400, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.15.2 release.
> > There are 61 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> You'll probably want to include the fixes for CVE-2014-0206 -- these are  
> edfbbf388f293d70bf4b7c0bc38774d05e6f711a and 
> f8567a3845ac05bb28f3c1b478ef752762bd39ef .

I'll get them in the next release in a few days, thanks.

greg k-h
