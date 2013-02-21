Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074Ab3BUQI1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 11:08:27 -0500
Received: from mail.skyhub.de ([78.46.96.112]:34551 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754063Ab3BUQIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 11:08:25 -0500
Date: Thu, 21 Feb 2013 17:08:21 +0100
From: Borislav Petkov <bp@alien8.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH EDACv2 01/12] edac: add support for raw error reports
Message-ID: <20130221160821.GH4694@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Edac Mailing List <linux-edac@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <cover.1361459782.git.mchehab@redhat.com>
 <30b4b936bf5eb2a47613cd3d5a256e4e9c56e911.1361459782.git.mchehab@redhat.com>
 <20130221155337.GG4694@pd.tnic>
 <20130221130125.7f649d4c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130221130125.7f649d4c@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2013 at 01:01:25PM -0300, Mauro Carvalho Chehab wrote:
> I did this way to to follow the "one patch per logical change rule".
> The rationale for this patch is to allow doing raw error reports,
> as needed by changeset 06/12.

Right, but you're adding a new function so why not add the right version
from the get-go? Otherwise the rule above would apply but not for new
code, right?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
