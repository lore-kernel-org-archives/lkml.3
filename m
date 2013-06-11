Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998Ab3FKGtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 02:49:18 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:57155 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751079Ab3FKGtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 02:49:16 -0400
Date: Tue, 11 Jun 2013 07:49:12 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Linux EFI <linux-efi@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Jiri Kosina <jkosina@suse.cz>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 1/4] efi: Convert runtime services function ptrs
Message-ID: <20130611064912.GG31198@console-pimps.org>
References: <1370177770-26661-1-git-send-email-bp@alien8.de>
 <1370177770-26661-2-git-send-email-bp@alien8.de>
 <20130606100745.GF30420@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130606100745.GF30420@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Jun, at 11:07:45AM, Matt Fleming wrote:
> Thanks! I've chucked this into my 'urgent' queue because it's a pretty
> straight forward cleanup and there's no point in allowing it to bitrot
> any further (the change to eboot.c is already stale).

OK, I chickened out of sending this in my latest pull request after
reading Linus' -rc5 email about him not wanting to see any non-critical
changes. I've stuck it in the 'next' branch with the rest of the stuff
for v3.11.

-- 
Matt Fleming, Intel Open Source Technology Center
