Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453Ab3IBIUA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 04:20:00 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:60334 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753890Ab3IBIT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:19:58 -0400
Date: Mon, 2 Sep 2013 09:19:53 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Andrew Fish <afish@apple.com>
Cc: edk2-devel@lists.sourceforge.net, Laszlo Ersek <lersek@redhat.com>,
        linux-efi@vger.kernel.org, Gleb Natapov <gleb@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Brian Richardson <brian.richardson@intel.com>,
        Colin Ian King <colin.king@canonical.com>
Subject: Re: [edk2] Corrupted EFI region
Message-ID: <20130902081953.GC28598@console-pimps.org>
References: <52001896.1030509@redhat.com>
 <20130805220808.GC14067@pd.tnic>
 <20130806141036.GD14891@pd.tnic>
 <520116D1.2010000@redhat.com>
 <20130807151935.GJ17920@pd.tnic>
 <CCFD3CBD-62B0-4046-B96D-18CB1A815F72@apple.com>
 <20130807201908.GG2515@console-pimps.org>
 <D5982201-6DC4-469F-812A-74A8402ADEE9@apple.com>
 <20130808101730.GJ2515@console-pimps.org>
 <1AEC7AA8-D49E-485F-A634-31B4F0D07083@apple.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1AEC7AA8-D49E-485F-A634-31B4F0D07083@apple.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Aug, at 06:46:02AM, Andrew Fish wrote:
> 
> On Aug 8, 2013, at 3:17 AM, Matt Fleming <matt@console-pimps.org> wrote:
> 
> > On Wed, 07 Aug, at 02:10:28PM, Andrew Fish wrote:
> >> Well the issue I see is I don't think OS X or Windows are doing this.
> >> So I'm guessing there is some unique thing beings done on the Linux
> >> side and we don't have good tests to catch bugs in the EFI
> >> implementations. If the Linux loader hides the bugs and we don't hit
> >> them with other operating systems they are never going to get fixed.
> >> It would be good if we could track down some of these issues and make
> >> a request for some tests that can help catch these issues. The tests
> >> would be part of UEFI.org, but since some of us play in both worlds we
> >> can forward the known issues to the UEFI test work group. 
> > 
> > I'm all for helping to develop tests that catch these kind of bugs.
> > What's the next step?
> > 
> 
> I'll bring this up with UEFI.org.
 
For those attending the UEFI plugfest in New Orleans this would be a
good topic for discussion - figuring out a collaboration process to get
new tests in place.

-- 
Matt Fleming, Intel Open Source Technology Center
