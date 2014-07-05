Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932694AbaGEUNZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 16:13:25 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:33538 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932301AbaGEUNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 16:13:24 -0400
Date: Sat, 5 Jul 2014 23:12:49 +0300
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
Message-ID: <20140705201249.GF25934@mwanda>
References: <1404564507-21718-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20140705192317.GD25934@mwanda>
 <CAMuHMdVNgCFZ1Nu77ds62COtqMPRYw4p_fifoZnAQKjq_D+kOQ@mail.gmail.com>
 <20140705200430.GE25934@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140705200430.GE25934@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Verifying the email address is not 100% fool proof so it's not a massive
deal either way.  The only reason I mentioned it here was because this
patch wasn't correct anyway and had to be redone regardless.

regards,
dan carpenter

