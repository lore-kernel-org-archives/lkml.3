Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787AbaFPTJj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 15:09:39 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:44576 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498AbaFPTJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 15:09:38 -0400
Date: Mon, 16 Jun 2014 22:09:33 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Monam Agarwal <monamagarwal123@gmail.com>
Subject: Re: [PATCH] staging: ced1401: userspace: use1401.c: Cleaning up
 potential strncpy missing null-terminate
Message-ID: <20140616190933.GJ5500@mwanda>
References: <1402785707-12383-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <1402785707-12383-2-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20140616190114.GI5500@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140616190114.GI5500@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 10:01:14PM +0300, Dan Carpenter wrote:
> 
> No one calls U14DriverName() so just delete this function.

Oh.  This is a userspace library or something?  I'm not sure what to do.

How did you compile test this?  Does your platform even provide
strlcpy()?

Anyway, don't delete it like I said, but I still don't think your patch
helps here.

regards,
dan carpenter

