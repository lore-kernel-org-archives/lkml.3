Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131AbbAMLAF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 06:00:05 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:22416 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbbAMLAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 06:00:02 -0500
Date: Tue, 13 Jan 2015 13:59:33 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, tvboxspy@gmail.com,
        devel@driverdev.osuosl.org, Emrys Bayliss <emrys@paradise.net.nz>,
        forest@alittletooquiet.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Staging: vt6656: Checkpatch fix: else after break or
 return
Message-ID: <20150113105933.GC5571@mwanda>
References: <1421081496-15772-1-git-send-email-emrys@paradise.net.nz>
 <20150113052312.GA3497@sudip-PC>
 <20150113055817.GA10754@kroah.com>
 <20150113062427.GA8265@sudip-PC>
 <20150113064840.GA17714@sudip-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150113064840.GA17714@sudip-PC>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 12:18:40PM +0530, Sudip Mukherjee wrote:
> On Tue, Jan 13, 2015 at 11:54:27AM +0530, Sudip Mukherjee wrote:
> > On Mon, Jan 12, 2015 at 09:58:17PM -0800, Greg KH wrote:
> > > On Tue, Jan 13, 2015 at 10:53:12AM +0530, Sudip Mukherjee wrote:
> > > > 
> > > > any reason why this return was removed ?
> > > 
> > > Because it's not needed.
> > 
> > yes, it is not needed. but the way Emrys Bayliss has changed the code, then we will get a compiler warning about no return statement.
> i should have mentioned in my last mail that compiler will give waring if we compile with W=3 
> 

1) Your compiler is crap.
2) You should ignore obviously incorrect warnings.

I'm using GCC 4.7.2 and it doesn't give a warning for this.  W=3 gives a
million other totally worthless warnings though.  W=3 is not useful.

regards,
dan carpenter

