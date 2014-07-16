Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbaGPV2C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:28:02 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:49490 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752804AbaGPV17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:27:59 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mark Brown <broonie@kernel.org>
Cc: Lv Zheng <lv.zheng@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH v3 7/7] ACPI: Cleanup useless ACPI inclusion.
Date: Wed, 16 Jul 2014 23:46:14 +0200
Message-ID: <4307509.CpjlMkz69H@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140716120750.GM17528@sirena.org.uk>
References: <cover.1387336613.git.lv.zheng@intel.com> <7ac00c9c5a32f7a3ec98f061080ba1573ae57d0d.1405500886.git.lv.zheng@intel.com> <20140716120750.GM17528@sirena.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 16, 2014 01:07:50 PM Mark Brown wrote:
> 
> --5me2qT3T17SWzdxI
> Content-Type: text/plain; charset=us-ascii
> Content-Disposition: inline
> 
> On Wed, Jul 16, 2014 at 04:59:02PM +0800, Lv Zheng wrote:
> > The sst-haswell-dsp.c is an ACPI independent file, this patch removes
> > ACPI header files for it.
> 
> Applied, thanks.  Please use subject lines matching the style for the
> subsystem and send at least the cover letter for the series to everyone
> so that they know what's going on with dependencies and so on.

Lv thought that this would go through the ACPI tree I suppose.

Rafael

