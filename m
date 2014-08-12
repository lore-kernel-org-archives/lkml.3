Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614AbaHLRm2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 13:42:28 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:60314 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbaHLRm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 13:42:27 -0400
Date: Tue, 12 Aug 2014 23:12:11 +0530
From: Srikrishan Malik <srikrishanmalik@gmail.com>
To: "Drokin, Oleg" <oleg.drokin@intel.com>
Cc: "<greg@kroah.com>" <greg@kroah.com>,
        "Dilger, Andreas" <andreas.dilger@intel.com>,
        "<devel@driverdev.osuosl.org>" <devel@driverdev.osuosl.org>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 08/13] staging: lustre: fix multi line strings
Message-ID: <20140812174211.GA27354@mordor>
Mail-Followup-To: Srikrishan Malik <srikrishanmalik@gmail.com>,
	"Drokin, Oleg" <oleg.drokin@intel.com>,
	"<greg@kroah.com>" <greg@kroah.com>,
	"Dilger, Andreas" <andreas.dilger@intel.com>,
	"<devel@driverdev.osuosl.org>" <devel@driverdev.osuosl.org>,
	"<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>
References: <1407781659-728-1-git-send-email-srikrishanmalik@gmail.com>
 <1407781659-728-8-git-send-email-srikrishanmalik@gmail.com>
 <FBE0C2BE-D82B-40E6-93B2-929E66130883@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FBE0C2BE-D82B-40E6-93B2-929E66130883@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 02:17:07AM +0000, Drokin, Oleg wrote:
> 
> On Aug 11, 2014, at 2:27 PM, Srikrishan Malik wrote:
> 
> > Fixes the following checkpatch warning:
> > 
> > WARNING: quoted string split across lines
> 
> > diff --git a/drivers/staging/lustre/lustre/mdc/mdc_request.c b/drivers/staging/lustre/lustre/mdc/mdc_request.c
> > index 57d903156917..6c691a4763b5 100644
> > --- a/drivers/staging/lustre/lustre/mdc/mdc_request.c
> > +++ b/drivers/staging/lustre/lustre/mdc/mdc_request.c
> > @@ -2055,8 +2055,8 @@ static int mdc_hsm_copytool_send(int len, void *val)
> > 		return -EPROTO;
> > 	}
> > 
> > -	CDEBUG(D_HSM, " Received message mg=%x t=%d m=%d l=%d actions=%d "
> > -	       "on %s\n",
> > +	CDEBUG(D_HSM,
> > +	       " Received message mg=%x t=%d m=%d l=%d actions=%d on %s\n",
> > 	       lh->kuc_magic, lh->kuc_transport, lh->kuc_msgtype,
> > 	       lh->kuc_msglen, hal->hal_count, hal->hal_fsname);
> 
> I imagine we can drop the leading space here as well.

ok, I will resend this patch including the suggested change.
I was not sure if we can do this in single patch.

> 
> Thanks.
> 
> Bye,
>     Oleg
