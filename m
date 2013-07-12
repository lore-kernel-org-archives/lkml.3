Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933167Ab3GLPIE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 11:08:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50946 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932845Ab3GLPIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 11:08:02 -0400
Date: Fri, 12 Jul 2013 08:08:58 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 00/11] 3.4.53-stable review
Message-ID: <20130712150858.GA10410@kroah.com>
References: <20130711220545.542911892@linuxfoundation.org>
 <20130712145846.GT5403@kvack.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130712145846.GT5403@kvack.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 10:58:46AM -0400, Benjamin LaHaise wrote:
> On Thu, Jul 11, 2013 at 03:11:00PM -0700, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.4.53 release.
> > There are 11 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> This seems to be missing e643692138cfa33528f054b071ba2583509bb217 -- 
> "ext3: fix data=journal fast mount/umount hang" which I submitted last 
> week.

Lots of patches are "missing", please see the announcement for
3.10.1 for why.

It's not lost, it will get there eventually...

thanks,

greg k-h
