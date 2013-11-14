Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344Ab3KNVBy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 16:01:54 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:58016 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756157Ab3KNVBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 16:01:47 -0500
Date: Thu, 14 Nov 2013 21:01:30 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: David Cohen <david.a.cohen@linux.intel.com>
Cc: matthew.garrett@nebula.com, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org, eric.ernst@linux.intel.com,
        Kuppuswamy Sathyanarayanan 
	<sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: Re: [PATCH 2/3] ipc: Enabled ipc support for additional intel
 platforms
Message-ID: <20131114210130.0a25733a@alan.etchedpixels.co.uk>
In-Reply-To: <528508FA.5040109@linux.intel.com>
References: <1384373671-12814-1-git-send-email-david.a.cohen@linux.intel.com>
	<1384373671-12814-3-git-send-email-david.a.cohen@linux.intel.com>
	<20131114134311.01d24bc5@alan.etchedpixels.co.uk>
	<528508FA.5040109@linux.intel.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Nov 2013 09:31:38 -0800
David Cohen <david.a.cohen@linux.intel.com> wrote:

> On 11/14/2013 05:43 AM, One Thousand Gnomes wrote:
> > On Wed, 13 Nov 2013 12:14:30 -0800
> > David Cohen <david.a.cohen@linux.intel.com> wrote:
> >
> >> From: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
> >>
> >> Enabled ipc support for penwell, clovertrail & tangier platforms.
> >
> > At some point this really ought to be discoverable in your SFI, ACPI or
> > similar data tables not continually hard coded.
> 
> Agreed. But it depends on fw changes, which I believe to happen on
> newer platforms only. On driver side we need to fill the missing
> resource info with hardcoded values :/

Oh agreed entirely, but please twist the arms of those responsible and
make sure they are very keen to get it into the firmware ACPI tables
ASAP.. 8)
