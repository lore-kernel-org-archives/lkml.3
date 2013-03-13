Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934123Ab3CMSdo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 14:33:44 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:47229 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933082Ab3CMSdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 14:33:41 -0400
Message-ID: <1363199617.15011.310.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [PATCH] efivars: Allow disabling use as a pstore backend
From: Matt Fleming <matt.fleming@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, Seth Forshee <seth.forshee@canonical.com>
Date: Wed, 13 Mar 2013 18:33:37 +0000
In-Reply-To: <5140B674.8070308@zytor.com>
References: <1362678017-2862-1-git-send-email-seth.forshee@canonical.com>
	 <5138FAD9.7050504@zytor.com> <20130307205915.GF24233@thinkpad-t410>
	 <1362694529.15011.211.camel@mfleming-mobl1.ger.corp.intel.com>
	 <513911F9.8050308@zytor.com> <20130311211750.GB8440@thinkpad-t410>
	 <1363118073.15011.275.camel@mfleming-mobl1.ger.corp.intel.com>
	 <20130312211417.GC16558@thinkpad-t410>
	 <1363189770.15011.300.camel@mfleming-mobl1.ger.corp.intel.com>
	 <20130313170724.GB12157@thinkpad-t410> <5140B674.8070308@zytor.com>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-13 at 10:25 -0700, H. Peter Anvin wrote:
> I think there should be two compile-time options (one to compile in the
> EFI pstore code at all, and one to set its default.)

OK, sorry Seth, looks like I'm the one that misunderstood. I've picked
up your first two patches and pushed them out to the urgent branch.
Please check that they look OK - they required minor fixups.

