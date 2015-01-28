Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760728AbbA1Ve1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 16:34:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59694 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761549AbbA1UoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:44:04 -0500
Date: Wed, 28 Jan 2015 10:46:52 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: lizf@kernel.org
cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Zefan Li <lizefan@huawei.com>
Subject: Re: [PATCH 3.4 07/91] ACPI / cpuidle: fix deadlock between cpuidle_lock
 and cpu_hotplug.lock
In-Reply-To: <alpine.LNX.2.00.1501281045540.6510@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1501281046250.6510@pobox.suse.cz>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org> <1422418236-12852-13-git-send-email-lizf@kernel.org> <alpine.LNX.2.00.1501281045540.6510@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2015, Jiri Kosina wrote:

> > From: Jiri Kosina <jkosina@suse.cz>
> > 
> > 3.4.105-rc1 review patch.  If anyone has any objections, please let me know.
> 
> Please don't forget to include followup deadlock fix as well:
> 
> 	https://lkml.org/lkml/2015/1/20/983

Err, I responded to a wrong e-mail, ENOTENOUGHCOFEE. Sorry for the noise.

-- 
Jiri Kosina
SUSE Labs
