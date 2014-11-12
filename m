Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbaKLWGE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 17:06:04 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:16678 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbaKLWGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 17:06:01 -0500
Date: Thu, 13 Nov 2014 01:05:40 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, trivial@kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Coccinelle <cocci@systeme.lip6.fr>
Subject: Re: [PATCH v2 2/2] staging: rtl8188eu: Better memory clean-up in
 efuse_phymap_to_logical()
Message-ID: <20141112220540.GK5351@mwanda>
References: <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
 <544954FD.8040607@users.sourceforge.net>
 <20141029084702.GA18675@kroah.com>
 <5453CD0D.9010206@users.sourceforge.net>
 <alpine.DEB.2.10.1410311900201.2481@hadrien>
 <5463C10D.6020409@users.sourceforge.net>
 <5463C373.5050804@users.sourceforge.net>
 <20141112211438.GI6749@mwanda>
 <5463D62D.3010206@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5463D62D.3010206@users.sourceforge.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 10:50:37PM +0100, SF Markus Elfring wrote:
> >> +		goto cleanup1;
> > 
> > 1) Don't use GW-BASIC label names.  Label names should reflect what the
> > label does such as free_fuse_word or free_fuse_tabel.
> > 
> > 2) Don't use do-nothing labels.  Just return directly.
> 
> Does the document "CodingStyle" need any extensions for special cases?

I don't understand.

> Are there any update candidates in the chapter "7: Centralized exiting of functions"?

CodingStyle says:

"If there is no cleanup needed then just return directly."

What is not clear about that?

regards,
dan carpenter

