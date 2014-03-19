Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758970AbaCSWVP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 18:21:15 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:37166 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755899AbaCSWVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 18:21:13 -0400
Message-ID: <1395267671.2185.63.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH 02/11][SCSI]mpt2sas: Added new driver module Parameter
 disable_eedp to Disable EEDP Support
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>, jejb@kernel.org,
        linux-scsi@vger.kernel.org, Sathya.Prakash@lsi.com,
        Nagalakshmi.Nandigama@lsi.com, linux-kernel@vger.kernel.org,
        sreekanthreddy0547@gmail.com
Date: Wed, 19 Mar 2014 15:21:11 -0700
In-Reply-To: <yq1r464wm7s.fsf@sermon.lab.mkp.net>
References: <20140314153622.GA7947@lsi.com>
	 <yq1r464wm7s.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-03-14 at 16:37 -0400, Martin K. Petersen wrote:
> >>>>> "Sreekanth" == Reddy, Sreekanth <Sreekanth.Reddy@lsi.com> writes:
> 
> Sreekanth> A new mpt2sas driver module parameter 'disable_eedp' is added
> Sreekanth> to Disable EEDP support. By default DIF support is enabled in
> Sreekanth> the driver and this module parameter would allow users to
> Sreekanth> turn it off.
> 
> Why don't you just set the prot_mask module parameter to 0?

Is there an answer to this?  It's holding up your patch submission.

James


