Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933004Ab3CGPJr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 10:09:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47800 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755200Ab3CGPJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 10:09:45 -0500
Date: Thu, 7 Mar 2013 09:09:41 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Matt Fleming <matt.fleming@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        stable@vger.kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: Problem mounting efivarfs in 3.9
Message-ID: <20130307150941.GB24233@thinkpad-t410>
Mail-Followup-To: Matt Fleming <matt.fleming@intel.com>,
	linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
	stable@vger.kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>
References: <20130307145601.GA24233@thinkpad-t410>
 <1362668558.15011.203.camel@mfleming-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362668558.15011.203.camel@mfleming-mobl1.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 03:02:38PM +0000, Matt Fleming wrote:
> On Thu, 2013-03-07 at 08:56 -0600, Seth Forshee wrote:
> > Hi Matt,
> > 
> > I found myself unable to mount efivarfs on one of my machines in 3.9.
> > This is due to your patch to be more aggressive about validating
> > filenames. This machine had some crash dumps from pstore, which start
> > with "dump-type". However now efivars expects the guid to follow the
> > first '-' character, despite the fact that the efivars pstore code is
> > creating the file names starting with dump-type. Since these names fail
> > the validation the mount fails.
> 
> A patch to allow pstore names is in the pull request I sent to Peter and
> Ingo yesterday,
> 
> 	http://marc.info/?l=linux-kernel&m=136258373231608&w=2

Great. Thanks!

Seth
