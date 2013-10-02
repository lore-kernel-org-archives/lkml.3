Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545Ab3JBVZ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 17:25:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43161 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733Ab3JBVZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 17:25:56 -0400
Date: Wed, 2 Oct 2013 14:26:09 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Solomon Peachy <pizza@shaftnet.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ 70/71] cw1200: Dont perform SPI transfers in interrupt context
Message-ID: <20131002212609.GB12120@kroah.com>
References: <20130929192643.539596256@linuxfoundation.org>
 <20130929192648.304161702@linuxfoundation.org>
 <20131002022320.GB22070@shaftnet.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131002022320.GB22070@shaftnet.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 01, 2013 at 10:23:21PM -0400, Solomon Peachy wrote:
> On Sun, Sep 29, 2013 at 12:28:22PM -0700, Greg Kroah-Hartman wrote:
> > 3.11-stable review patch.  If anyone has any objections, please let me know.
> 
> If it's not too late, please drop this patch.  Sorry aobut the delay in 
> responding, I was travelling internationally and had very sporadic 
> connectivity.
> 
> The patch was reverted in this patch:
> 
> 	c4fb19d21b003ec99ec490ba2cb60baffabc73f3
> 
> And superceded by this one:
> 
> 	87421cb6010a2f6494938fbe0a95e1b096b3b7af
> 
> (Out of Linus's upstream tree)

Thanks, I've now applied both of these, which should resolve the issue,
right?

greg k-h
