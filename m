Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967247AbaFQWl0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:41:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55297 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965424AbaFQWlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 18:41:21 -0400
Message-ID: <1403044874.14743.36.camel@fourier>
Subject: Re: [PATCH 3.13 089/212] ACPI: Remove Kconfig symbol ACPI_PROCFS
From: Kamal Mostafa <kamal@canonical.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Date: Tue, 17 Jun 2014 15:41:14 -0700
In-Reply-To: <1403043991.1984.42.camel@x220>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
	 <1403041506-13646-90-git-send-email-kamal@canonical.com>
	 <1403043991.1984.42.camel@x220>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-18 at 00:26 +0200, Paul Bolle wrote:
> Kamal,
> 
> On Tue, 2014-06-17 at 14:43 -0700, Kamal Mostafa wrote:
> > 3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Paul Bolle <pebolle@tiscali.nl>
> > 
> > commit 7919010c4224e07b871f3b5513d245cc029fcd67 upstream.
> > 
> > Nothing cares about ACPI_PROCFS. This has been the case since v2.6.38.
> > This Kconfig symbol serves no purpose and its help text is now
> > misleading. It can safely be removed. If this symbol would be needed
> > again in the future it can be readded in a commit that adds code that
> > actually uses it.
> > 
> > Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > [ kamal: 3.13-stable prereq for
> >   e2a7c3d ACPI: Revert "ACPI: Remove CONFIG_ACPI_PROCFS_POWER and cm_sbsc.c" ]
> 
> I'm curious: how can this patch - which is straightforward cleanup,
> without any further impact - be a prerequisite for a revert, or anything
> else, for that matter?

Hi Paul-

Pulling in this cleanup patch allowed me to cleanly cherry-pick e2a7c3d.
Yes, it would have been possible to massage e2a7c3d into applying but
just cherry-picking both yields a cleaner end result, so that's what I
opted to do for this case.

 -Kamal

> > Signed-off-by: Kamal Mostafa <kamal@canonical.com>
> 
> 
> Paul Bolle
> 


