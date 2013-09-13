Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676Ab3IMM4U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 08:56:20 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:36557 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab3IMM4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 08:56:18 -0400
Date: Fri, 13 Sep 2013 15:56:05 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>,
        Ramprasad Chinthekindi <rchinthekindi@stec-inc.com>,
        Akhil Bhansali <abhansali@stec-inc.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [patch 3/4] skd: use strncpy() as a cleanup
Message-ID: <20130913125605.GL25896@mwanda>
References: <20130913080539.GG19211@elgon.mountain>
 <CAMuHMdX88cUEu2dmamEttK=9Lv0TKiZauCtPDLbgKUde+8ufyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdX88cUEu2dmamEttK=9Lv0TKiZauCtPDLbgKUde+8ufyQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 02:03:23PM +0200, Geert Uytterhoeven wrote:
> On Fri, Sep 13, 2013 at 10:05 AM, Dan Carpenter
> > +       strncpy(inq.driver_version, DRV_VER_COMPL,
> > +               min(sizeof(inq.driver_version), strlen(DRV_VER_COMPL)));
> 
> This does the exact same thing as memcpy(), right? So why not use that?
> memcpy() has much simpler semantics than strncpy().

You're right.  I've redone this.

regards,
dan carpenter

