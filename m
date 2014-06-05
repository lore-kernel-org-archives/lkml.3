Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284AbaFEP6O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 11:58:14 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:43856 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751791AbaFEP6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 11:58:12 -0400
X-Sasl-enc: uVvh/ejGiVgNz9T8Kh7uyGtUt81i2AQzoZ4J+Zg4AzZF 1401983890
Date: Thu, 5 Jun 2014 09:01:51 -0700
From: Greg KH <greg@kroah.com>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?= 
	<holger.hoffstaette@googlemail.com>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.14 000/228] 3.14.6-stable review
Message-ID: <20140605160151.GG23993@kroah.com>
References: <20140604232347.966798903@linuxfoundation.org>
 <pan.2014.06.05.08.15.58@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <pan.2014.06.05.08.15.58@googlemail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2014 at 08:15:58AM +0000, Holger Hoffstätte wrote:
> On Wed, 04 Jun 2014 16:20:29 -0700, Greg Kroah-Hartman wrote:
> 
> > This is the start of the stable review cycle for the 3.14.6 release.
> 
> Built & running fine on 3 different machines (x86_64), mix of old and new 
> HW. So far no regressions. Minor hitch: the Makefile did not apply 
> cleanly for me because apparently the release name changed too; not sure 
> if that was intended.

What do you mean by this?  The release name changed in the 3.14.5
release, right?  Not in this patch set.  What did you apply this patch
to?

thanks,

greg k-h
