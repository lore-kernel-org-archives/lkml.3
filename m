Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744Ab3HASBu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 14:01:50 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:57407 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507Ab3HASBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 14:01:48 -0400
Date: Thu, 1 Aug 2013 19:01:44 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Aaron Lu <aaron.lwe@gmail.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Len Brown <lenb@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [REGRESSION/PATCH] acpi: blacklist win8 OSI for ASUS Zenbok
 Prime UX31A
Message-ID: <20130801180144.GA20520@srcf.ucam.org>
References: <20130731051421.GA15766@srcf.ucam.org>
 <CAMP44s2B=nQLnZm7gyYAJZgt_x3KszRZLUC=fom0t9=Eze+smA@mail.gmail.com>
 <20130731140010.GA24560@srcf.ucam.org>
 <CAMP44s1cLou9TMfLS+FHwPM_b3bG5HN1-hzgvhz0fVRCZ8XqWw@mail.gmail.com>
 <20130731175232.GA29987@srcf.ucam.org>
 <CAMP44s1c5pmiC2fvmRi9vFrJXb2zYUT_F=paM2LR_V+7THnFVg@mail.gmail.com>
 <20130731184724.GA30896@srcf.ucam.org>
 <CAMP44s25aRcK2bB=WLMkuD45fztFBNug8prArczRqZqzeEvj3A@mail.gmail.com>
 <20130801174237.GA20121@srcf.ucam.org>
 <CAMP44s3EgZBtv-ifO9b+VzmTBE2wejNK7RN3ERL0+imrXzgBCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMP44s3EgZBtv-ifO9b+VzmTBE2wejNK7RN3ERL0+imrXzgBCg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 12:50:18PM -0500, Felipe Contreras wrote:
> On Thu, Aug 1, 2013 at 12:42 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > An interface that describes reality is better than one that doesn't. But
> > hey, feel free to disagree and post a patch for the ABI docs.
> 
> An interface that is useful to the user is better than one that is not.

The interface is useful. There are plenty of machines out there that 
disable the backlight at minimum brightness setting (see every Apple, 
for example), and assuming otherwise has always been incorrect. But, 
like I said, send the patch.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
