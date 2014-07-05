Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420AbaGEUHo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 16:07:44 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:33153 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756058AbaGEUHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 16:07:42 -0400
Date: Sat, 5 Jul 2014 23:04:30 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Rickard Strandqvist <rickard.strandqvist@sonymobile.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "Chen, Gong" <gong.chen@linux.intel.com>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] video: fbdev: sis: init.c: Cleaning up variable that is
 never used
Message-ID: <20140705200430.GE25934@mwanda>
References: <1404564507-21718-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20140705192317.GD25934@mwanda>
 <CAMuHMdVNgCFZ1Nu77ds62COtqMPRYw4p_fifoZnAQKjq_D+kOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdVNgCFZ1Nu77ds62COtqMPRYw4p_fifoZnAQKjq_D+kOQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 05, 2014 at 09:44:56PM +0200, Geert Uytterhoeven wrote:
> On Sat, Jul 5, 2014 at 9:23 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> > On Sat, Jul 05, 2014 at 02:48:27PM +0200, Rickard Strandqvist wrote:
> >> From: Rickard Strandqvist <rickard.strandqvist@sonymobile.com>
> >
> > These for lines are for when you are sending on someone else's behalf.
> 
> Or for when you are sending the patches from a different email address
> than the one that should be recorded in git.
>

Yeah.  But it's better to fix your email client so we can at least
verify that the signed off matches the author tag.

I know a lot of people have trouble configuring email but in the end
everyone pretty much manages when we ask them to.

regards,
dan carpenter

