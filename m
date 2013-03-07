Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932801Ab3CGNGl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 08:06:41 -0500
Received: from mail.skyhub.de ([78.46.96.112]:60621 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932278Ab3CGNGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 08:06:40 -0500
Date: Thu, 7 Mar 2013 14:06:35 +0100
From: Borislav Petkov <bp@alien8.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-edac <linux-edac@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] EDAC fixes for 3.8
Message-ID: <20130307130635.GD5239@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-edac <linux-edac@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>
References: <20121211140108.GC4303@liondog.tnic>
 <20130307095703.03d040ee@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130307095703.03d040ee@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 09:57:03AM -0300, Mauro Carvalho Chehab wrote:
> After running my edac testbanch on an AMD64 machine, populated
> with 4 DIMMS, each being a 4GB QUAD-rank DIMMs, the EDAC driver
> reported 4 different memory configurations ;)

Can you please enable CONFIG_EDAC_DEBUG and send me dmesg?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
