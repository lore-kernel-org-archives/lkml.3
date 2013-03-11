Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258Ab3CKObm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 10:31:42 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50943 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750872Ab3CKObl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 10:31:41 -0400
Date: Mon, 11 Mar 2013 15:31:38 +0100
From: Borislav Petkov <bp@alien8.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-edac <linux-edac@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] EDAC fixes for 3.8
Message-ID: <20130311143138.GC5000@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-edac <linux-edac@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>
References: <20121211140108.GC4303@liondog.tnic>
 <20130307095703.03d040ee@redhat.com>
 <20130307130635.GD5239@pd.tnic>
 <20130307110213.7a5a9978@redhat.com>
 <20130309154635.GA18316@pd.tnic>
 <20130311090746.199a4c06@redhat.com>
 <20130311092848.652c0d46@redhat.com>
 <20130311134814.GB5000@pd.tnic>
 <20130311111215.3f12e9ee@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130311111215.3f12e9ee@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 11:12:15AM -0300, Mauro Carvalho Chehab wrote:
> Ok, I'll test it on a K8 box at RH.
>
> The bug seems to be on K8 rev F, right? Is there a different PCI ID on
> those machines? That would help me to quickly find such machine on at
> RH labs.

K8 revF should be a good choice, yes. Anything with model >= 40 in
/proc/cpuinfo.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
