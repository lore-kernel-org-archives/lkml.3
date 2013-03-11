Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255Ab3CKUnH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 16:43:07 -0400
Received: from mail.skyhub.de ([78.46.96.112]:54787 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753438Ab3CKUnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 16:43:05 -0400
Date: Mon, 11 Mar 2013 21:43:03 +0100
From: Borislav Petkov <bp@alien8.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-edac <linux-edac@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] EDAC fixes for 3.8
Message-ID: <20130311204303.GG5000@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-edac <linux-edac@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>
References: <20130307095703.03d040ee@redhat.com>
 <20130307130635.GD5239@pd.tnic>
 <20130307110213.7a5a9978@redhat.com>
 <20130309154635.GA18316@pd.tnic>
 <20130311090746.199a4c06@redhat.com>
 <20130311092848.652c0d46@redhat.com>
 <20130311134814.GB5000@pd.tnic>
 <20130311111215.3f12e9ee@redhat.com>
 <20130311143138.GC5000@pd.tnic>
 <20130311170837.4c987c43@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130311170837.4c987c43@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 05:08:37PM -0300, Mauro Carvalho Chehab wrote:
> While this machine is reserved for my usage, do you need a different
> test on it?

Yes please. Can you send dmesg and sysfs entries before applying your
patches?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
