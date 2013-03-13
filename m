Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934169Ab3CMTPJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 15:15:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48739 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933082Ab3CMTPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 15:15:07 -0400
Date: Wed, 13 Mar 2013 14:14:55 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Matt Fleming <matt.fleming@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [PATCH] efivars: Allow disabling use as a pstore backend
Message-ID: <20130313191455.GC12157@thinkpad-t410>
Mail-Followup-To: Matt Fleming <matt.fleming@intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Matthew Garrett <matthew.garrett@nebula.com>,
	linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
References: <20130307205915.GF24233@thinkpad-t410>
 <1362694529.15011.211.camel@mfleming-mobl1.ger.corp.intel.com>
 <513911F9.8050308@zytor.com>
 <20130311211750.GB8440@thinkpad-t410>
 <1363118073.15011.275.camel@mfleming-mobl1.ger.corp.intel.com>
 <20130312211417.GC16558@thinkpad-t410>
 <1363189770.15011.300.camel@mfleming-mobl1.ger.corp.intel.com>
 <20130313170724.GB12157@thinkpad-t410>
 <5140B674.8070308@zytor.com>
 <1363199617.15011.310.camel@mfleming-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363199617.15011.310.camel@mfleming-mobl1.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 06:33:37PM +0000, Matt Fleming wrote:
> On Wed, 2013-03-13 at 10:25 -0700, H. Peter Anvin wrote:
> > I think there should be two compile-time options (one to compile in the
> > EFI pstore code at all, and one to set its default.)
> 
> OK, sorry Seth, looks like I'm the one that misunderstood. I've picked
> up your first two patches and pushed them out to the urgent branch.
> Please check that they look OK - they required minor fixups.

A minor nit from the second patch:

+static bool efivars_pstore_disable = \
+       IS_ENABLED(EFI_VARS_PSTORE_DEFAULT_DISABLE);

The backslash isn't necessary.

Otherwise everything looks fine afaict.

Thanks,
Seth

