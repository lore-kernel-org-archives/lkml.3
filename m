Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491AbaGHIpo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 04:45:44 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:31308 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbaGHIpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 04:45:41 -0400
Date: Tue, 8 Jul 2014 11:45:18 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Fabio Falzoi <fabio.falzoi84@gmail.com>
Cc: micky <micky_ching@realsil.com.cn>, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, wei_wang@realsil.com.cn,
        Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] Staging: rts5208: Replace custom macro with
 print_hex_dump_bytes
Message-ID: <20140708084517.GG25880@mwanda>
References: <1404717004-29540-1-git-send-email-fabio.falzoi84@gmail.com>
 <1404717004-29540-3-git-send-email-fabio.falzoi84@gmail.com>
 <53BB538C.1080605@realsil.com.cn>
 <CACar8LkcvOc5dEkFp2pCMmtiO=e7_zOK-2NYhGz6AmQYu2bh-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACar8LkcvOc5dEkFp2pCMmtiO=e7_zOK-2NYhGz6AmQYu2bh-g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 08:23:02AM +0200, Fabio Falzoi wrote:
> >
> > Hi,
> > here exist some checkpatch errors.
> >
> > Best Regards.
> > micky.
> 
> Yes, you'are right, I'm gonna fix it, thanks.

And leave out the semi-colon as well.

regards,
dan carpenter

