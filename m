Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967598AbaFQW0f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:26:35 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:51119 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965630AbaFQW0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 18:26:33 -0400
Message-ID: <1403043991.1984.42.camel@x220>
Subject: Re: [PATCH 3.13 089/212] ACPI: Remove Kconfig symbol ACPI_PROCFS
From: Paul Bolle <pebolle@tiscali.nl>
To: Kamal Mostafa <kamal@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Date: Wed, 18 Jun 2014 00:26:31 +0200
In-Reply-To: <1403041506-13646-90-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
	 <1403041506-13646-90-git-send-email-kamal@canonical.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Jun 2014 22:26:31.0416 (UTC) FILETIME=[305EBF80:01CF8A7B]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kamal,

On Tue, 2014-06-17 at 14:43 -0700, Kamal Mostafa wrote:
> 3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Paul Bolle <pebolle@tiscali.nl>
> 
> commit 7919010c4224e07b871f3b5513d245cc029fcd67 upstream.
> 
> Nothing cares about ACPI_PROCFS. This has been the case since v2.6.38.
> This Kconfig symbol serves no purpose and its help text is now
> misleading. It can safely be removed. If this symbol would be needed
> again in the future it can be readded in a commit that adds code that
> actually uses it.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> [ kamal: 3.13-stable prereq for
>   e2a7c3d ACPI: Revert "ACPI: Remove CONFIG_ACPI_PROCFS_POWER and cm_sbsc.c" ]

I'm curious: how can this patch - which is straightforward cleanup,
without any further impact - be a prerequisite for a revert, or anything
else, for that matter?

> Signed-off-by: Kamal Mostafa <kamal@canonical.com>


Paul Bolle

