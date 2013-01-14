Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757149Ab3ANO2d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 09:28:33 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:34292 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756706Ab3ANO2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 09:28:32 -0500
Date: Mon, 14 Jan 2013 06:29:21 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/11] extcon-arizona updates
Message-ID: <20130114142921.GB20384@kroah.com>
References: <20130110120231.GL20956@opensource.wolfsonmicro.com>
 <50EF71C3.6060009@samsung.com>
 <20130114075923.GD4833@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130114075923.GD4833@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 04:59:25PM +0900, Mark Brown wrote:
> On Fri, Jan 11, 2013 at 10:58:27AM +0900, Chanwoo Choi wrote:
> 
> > Applied this patch set.
> 
> > You can check this on extcon git repository:
> > http://git.kernel.org/?p=linux/kernel/git/chanwoo/extcon.git;a=shortlog;h=refs/heads/for-next
> 
> Looks good.  It does seem this tree isn't in -next, though - if this
> tree ends up getting sent to Linus (via Greg I guess?) it'd make sense
> to do that so we get integration testing for it as soon as possible.

It would be good if Chanwoo sent me pull requests, I thought that was
going to happen but I have not seen any yet...
