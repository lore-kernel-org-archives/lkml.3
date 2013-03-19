Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933460Ab3CSRRf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 13:17:35 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39686 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933243Ab3CSRRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 13:17:31 -0400
Message-ID: <1363713447.2377.60.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH] x86/efi: pull NV+BS variables out before we exit boot
 services
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-efi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 19 Mar 2013 17:17:27 +0000
In-Reply-To: <20130319163531.GA10879@srcf.ucam.org>
References: <1363596014.2412.8.camel@dabdike.int.hansenpartnership.com>
	 <20130319014850.GA28934@srcf.ucam.org>
	 <1363680885.2377.11.camel@dabdike.int.hansenpartnership.com>
	 <20130319163531.GA10879@srcf.ucam.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.6.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-19 at 16:35 +0000, Matthew Garrett wrote:
> On Tue, Mar 19, 2013 at 08:14:45AM +0000, James Bottomley wrote:
> 
> > Any security assumptions that rely on inability to read certain
> > information aren't really going to be that secure.  Inability to modify,
> > sure, but inability to read, not really.
> 
> Well, I guess that's public/private key cryptography screwed.

Well, OK, it's ex-BIOS writers we're dealing with, so I won't say no-one
would be stupid enough to come up with a security scheme embedding
Private Keys in BS+NV variables, but I would have thought the fact that
Linux would blow the lid off it might be a good incentive not to do it
and thus a plus point for this patch.

James


