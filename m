Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259AbaAWRCn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 12:02:43 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:47014 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbaAWRCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 12:02:42 -0500
Message-ID: <1390496192.1792.488.camel@misato.fc.hp.com>
Subject: Re: [PATCH 0/5] EFI memmap and other fixes, v3
From: Toshi Kani <toshi.kani@hp.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Matt Fleming <matt@console-pimps.org>,
        Linux EFI <linux-efi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 23 Jan 2014 09:56:32 -0700
In-Reply-To: <20140123165109.GA11190@pd.tnic>
References: <1390045698-16882-1-git-send-email-bp@alien8.de>
	 <20140123090654.GA17297@console-pimps.org>
	 <1390494619.1792.482.camel@misato.fc.hp.com>
	 <20140123165109.GA11190@pd.tnic>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-23 at 17:51 +0100, Borislav Petkov wrote:
> On Thu, Jan 23, 2014 at 09:30:19AM -0700, Toshi Kani wrote:
> > Since this issue is quite serious on our systems (3.14 kernels won't
> > boot up), I'd really appreciate if the fixes can be made into some
> > 3.14-rc.  It can hit on any EFI systems with large memory.
> 
> That's why we have "efi=old_map" - so that you can use the old mapping
> method which is a chicken bit for the new scheme.

Good point.  Yes, that will help us a lot.

> And I told you privately already that you're better off merging Matt's
> 'next' branch than us exposing this to the world too early. So stop
> pushing this when there are clearly other solutions for your case and be
> patient!

Right, but I just responded to Matt's query. :-) 

Thanks,
-Toshi


