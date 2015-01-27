Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758595AbbA0NIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 08:08:18 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:33637 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbbA0NIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 08:08:16 -0500
Date: Tue, 27 Jan 2015 18:38:04 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Thomas Winischhofer <thomas@winischhofer.net>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] video: fbdev: sis: remove unused variables
Message-ID: <20150127130804.GA25333@sudip-PC>
References: <1421940699-20670-1-git-send-email-sudipm.mukherjee@gmail.com>
 <54C63506.3020106@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C63506.3020106@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 02:37:26PM +0200, Tomi Valkeinen wrote:
> On 22/01/15 17:31, Sudip Mukherjee wrote:
> > removed some variables which were not used. Few calls to SiS_GetReg()
> > were left behind as they are reading from the hardare, removing them
> > might affect the overall functionality.
> > 
> > Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> > ---
> > This patch will generate checkpatch error, to fix that error we need
> > to change the style of init.c and init301.c
> > 
> >  drivers/video/fbdev/sis/init.c     | 33 +++++----------------------------
> >  drivers/video/fbdev/sis/init301.c  | 10 ++--------
> >  drivers/video/fbdev/sis/sis_main.c |  9 ++++-----
> >  3 files changed, 11 insertions(+), 41 deletions(-)
> 
> Are you able to test this?
> 
> The patch doesn't look too complex, but it's still slightly too complex
> for me to comfortably merge it without any testing.

No. It is not tested on actual hardware.

Sudip

> 
>  Tomi
> 
> 


