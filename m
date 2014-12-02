Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509AbaLBTEP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:04:15 -0500
Received: from lists.s-osg.org ([54.187.51.154]:38964 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932155AbaLBTEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:04:14 -0500
Date: Tue, 2 Dec 2014 17:04:08 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Aristeu Rozanski <aris@redhat.com>
Cc: Tony Luck <tony.luck@intel.com>, Doug Thompson <dougthompson@xmission.com>,
        Borislav Petkov <bp@alien8.de>, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sb_edac: Fix typo computing number of banks
Message-ID: <20141202170408.4f2afa35@recife.lan>
In-Reply-To: <20141202181757.GE21208@redhat.com>
References: <088380@agluck-desk.sc.intel.com>
	<20141202181757.GE21208@redhat.com>
Organization: Samsung
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, 2 Dec 2014 13:17:58 -0500
Aristeu Rozanski <aris@redhat.com> escreveu:

> On Tue, Dec 02, 2014 at 09:41:58AM -0800, Tony Luck wrote:
> > Code will always think there are 16 banks because of a typo
> > 
> > Reported-by: Misha
> > Signed-off-by: Tony Luck <tony.luck@intel.com>

Applied, thanks!

> > ---
> > 
> > Not sure if Misha is shy, or just busy. But my attempt to get
> > them to post their own patch didn't work
> > 
> >  drivers/edac/sb_edac.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
> > index 993e8b61c4b2..63aa6730e89e 100644
> > --- a/drivers/edac/sb_edac.c
> > +++ b/drivers/edac/sb_edac.c
> > @@ -901,7 +901,7 @@ static int get_dimm_config(struct mem_ctl_info *mci)
> >  	else
> >  		edac_dbg(0, "Memory is unregistered\n");
> >  
> > -	if (mtype == MEM_DDR4 || MEM_RDDR4)
> > +	if (mtype == MEM_DDR4 || mtype == MEM_RDDR4)
> >  		banks = 16;
> >  	else
> >  		banks = 8;
> 
> ACK
> 
