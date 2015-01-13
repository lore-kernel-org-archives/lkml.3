Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543AbbAMGsw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 01:48:52 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:40856 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbbAMGsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 01:48:51 -0500
Date: Tue, 13 Jan 2015 12:18:40 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Emrys Bayliss <emrys@paradise.net.nz>, forest@alittletooquiet.net,
        tvboxspy@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Staging: vt6656: Checkpatch fix: else after break or
 return
Message-ID: <20150113064840.GA17714@sudip-PC>
References: <1421081496-15772-1-git-send-email-emrys@paradise.net.nz>
 <20150113052312.GA3497@sudip-PC>
 <20150113055817.GA10754@kroah.com>
 <20150113062427.GA8265@sudip-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150113062427.GA8265@sudip-PC>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 11:54:27AM +0530, Sudip Mukherjee wrote:
> On Mon, Jan 12, 2015 at 09:58:17PM -0800, Greg KH wrote:
> > On Tue, Jan 13, 2015 at 10:53:12AM +0530, Sudip Mukherjee wrote:
> > > 
> > > any reason why this return was removed ?
> > 
> > Because it's not needed.
> 
> yes, it is not needed. but the way Emrys Bayliss has changed the code, then we will get a compiler warning about no return statement.
i should have mentioned in my last mail that compiler will give waring if we compile with W=3 

sudip

> the code becomes :
> 
