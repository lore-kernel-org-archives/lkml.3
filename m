Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932754Ab3DBUDB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 16:03:01 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:65074 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932593Ab3DBUDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 16:03:00 -0400
Date: Tue, 2 Apr 2013 13:02:57 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jonghwan Choi <jhbird.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "'Liam Girdwood'" <lrg@ti.com>,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        "'Russ Dill'" <Russ.Dill@ti.com>
Subject: Re: [PATCH 3.8-stable] regulator: core: Log when a device causes a
 voltage
Message-ID: <20130402200257.GB8177@kroah.com>
References: <009001ce2f84$beb22ea0$3c168be0$%choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <009001ce2f84$beb22ea0$3c168be0$%choi@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02, 2013 at 06:30:42PM +0900, Jonghwan Choi wrote:
> 3.8-stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> 
> From: "Russ Dill <Russ.Dill@ti.com>"
> 
> commit 6e45eb12fd1c741d556bf264ee98853b5f3104e5 upstream.

Wait, no, this is NOT the commit id of this patch, please don't get this
wrong.

I've dropped this from my stable mbox, if Russ feels this should go to
3.8-stable, please send me the correct git id of the patch to apply.

thanks,

greg k-h
