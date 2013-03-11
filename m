Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab3CKNsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 09:48:18 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52814 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690Ab3CKNsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 09:48:16 -0400
Date: Mon, 11 Mar 2013 14:48:14 +0100
From: Borislav Petkov <bp@alien8.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-edac <linux-edac@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] EDAC fixes for 3.8
Message-ID: <20130311134814.GB5000@pd.tnic>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130311092848.652c0d46@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 09:28:48AM -0300, Mauro Carvalho Chehab wrote:
> With this patch, mci->csbased field got unused. So, it makes sense to
> also remove it. The enclosed patch does that.

AFAIR, this whole fixing was done for K8 as reported by Josh Hunt from
Akamai: http://marc.info/?l=linux-edac&m=134740440610678 (the whole
thread contains the discussion).

So, before we go and change anything in amd64_edac, we need to test
those on a K8 box. Now, I need ot find one but it would be good if you
could find one too at RH and test the patches on it before we continue
with this.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
