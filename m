Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441AbaIRWj1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 18:39:27 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:49894 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754532AbaIRWjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 18:39:25 -0400
Date: Fri, 19 Sep 2014 01:39:09 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peng Tao <bergwolf@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: lustre: lustre: libcfs: debug.c: Cleaning up
 unnecessary use of memset in conjunction with strncpy
Message-ID: <20140918223909.GO17875@mwanda>
References: <1410710597-14520-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20140915082346.GB17875@mwanda>
 <CAFo99gZUiSB2cgSAAj7EBjZJTs7QxvCDZr6Wms3ud5qQvBWQMw@mail.gmail.com>
 <20140918085105.GB16827@mwanda>
 <CAFo99gbNPLiEFSmeQOpeNwD=cSkXs79tfu2BJqZfmiX8dEsYWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFo99gbNPLiEFSmeQOpeNwD=cSkXs79tfu2BJqZfmiX8dEsYWA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 09:57:17PM +0200, Rickard Strandqvist wrote:
> 
> Should I add this as a patch in lib/string.c or email him first.. What
> is customary in these situations?
> 

Just write up a normal patch and try to merge it through the normal
methods.

It's not that controversial to do:

	strncpy(dest, src, n);
	dest[n] = '\0';

That's what we have been open coding all over the place anyway already.

regards,
dan carpenter

