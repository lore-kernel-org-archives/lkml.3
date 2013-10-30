Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959Ab3J3DFv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 23:05:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41072 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605Ab3J3DFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 23:05:50 -0400
Date: Tue, 29 Oct 2013 20:07:47 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Peter =?iso-8859-1?Q?H=FCwe?= <PeterHuewe@gmx.de>
Cc: Ashley Lai <ashley@ashleylai.com>, Rajiv Andrade <mail@srajiv.net>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] tpm/tpm_i2c_stm_st33: Check return code of
 get_burstcount (fix CID: 986658)
Message-ID: <20131030030747.GA12179@kroah.com>
References: <1383090860-15901-1-git-send-email-peterhuewe@gmx.de>
 <20131030000618.GA5241@kroah.com>
 <201310300142.11716.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201310300142.11716.PeterHuewe@gmx.de>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 01:42:11AM +0100, Peter Hüwe wrote:
> Hi Greg,
> > > 
> > > CID: 986658
> > What is this field for?
> 
> That's the scan id in the coverity database.
> If you think that's just noise I can leave it out.

It's noise as not everyone can see it or make anything out of it, so
please don't include it.

thanks,

greg k-h
