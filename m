Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055Ab3LLRlU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 12:41:20 -0500
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:19171 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab3LLRlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 12:41:17 -0500
Message-ID: <1386869777.1791.314.camel@misato.fc.hp.com>
Subject: Re: EFI tree kernel panic in phys_efi_set_virtual_address_map()
From: Toshi Kani <toshi.kani@hp.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org
Date: Thu, 12 Dec 2013 10:36:17 -0700
In-Reply-To: <1386869221.1791.311.camel@misato.fc.hp.com>
References: <1386806463.1791.295.camel@misato.fc.hp.com>
	 <20131212002946.GF8863@pd.tnic>
	 <1386808323.1791.299.camel@misato.fc.hp.com>
	 <1386810484.1791.306.camel@misato.fc.hp.com>
	 <1386810620.1791.307.camel@misato.fc.hp.com>
	 <20131212162351.GA26927@pd.tnic>
	 <1386866583.1791.310.camel@misato.fc.hp.com>
	 <1386869221.1791.311.camel@misato.fc.hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-12-12 at 10:27 -0700, Toshi Kani wrote:
> On Thu, 2013-12-12 at 09:43 -0700, Toshi Kani wrote:
> > On Thu, 2013-12-12 at 17:23 +0100, Borislav Petkov wrote:
> > > On Wed, Dec 11, 2013 at 06:10:20PM -0700, Toshi Kani wrote:
> > > > > Unfortunately, it did not work.  Hit the same panic again.
> > > > 
> > > > dmesg output attached.
> > > 
> > > Ok, thanks.
> > > 
> > > Let's have a look at the EFI pagetable then. Please apply the attached
> > > patch, make sure CONFIG_X86_PTDUMP is enabled, build, boot and catch
> > > full dmesg again and send it to me.
> > 
> > Yes, I will test with the change, and send a full dmesg output to you.
> 
> Attached.

BTW, the test system is shared and will be used by other test for a
couple of hours or so.  So, please take your time. :-)

Thanks!
-Toshi

