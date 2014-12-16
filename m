Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751347AbaLPJ2I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 04:28:08 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:51341 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbaLPJ2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 04:28:05 -0500
Date: Tue, 16 Dec 2014 12:27:17 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Joe Perches <joe@perches.com>, devel@driverdev.osuosl.org,
        Fabian Frederick <fabf@skynet.be>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        James Simmons <uja.ornl@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Oleg Drokin <oleg.drokin@intel.com>, Greg Donald <gdonald@gmail.com>,
        HPDD-discuss@ml01.01.org, Andriy Skulysh <Andriy_Skulysh@xyratex.com>,
        "John L. Hammond" <john.hammond@intel.com>
Subject: Re: [PATCH] staging: lustre: lustre: obdclass: lprocfs_status.c: Fix
 for possible null pointer dereference
Message-ID: <20141216092717.GG4856@mwanda>
References: <1418597547-25086-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <1418608297.2674.4.camel@perches.com>
 <CAFo99gaVUbsvwY7RKZ9D=c0jnVeFiBLAeNVb53UX=Ba4XytoKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFo99gaVUbsvwY7RKZ9D=c0jnVeFiBLAeNVb53UX=Ba4XytoKg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 11:23:25PM +0100, Rickard Strandqvist wrote:
> Hi Joe
> 
> No, it does not look like end can be NULL then.
> Then remove the end != NULL instead?
> ...
>     if (end != NULL && *end == '.') {
> 

Yes.  Please do.

regards,
dan carpenter

