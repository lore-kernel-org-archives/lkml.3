Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945Ab3AQWMr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 17:12:47 -0500
Received: from mail.skyhub.de ([78.46.96.112]:32905 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814Ab3AQWMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 17:12:45 -0500
Date: Thu, 17 Jan 2013 23:12:40 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Gopalakrishnan, Aravind" <Aravind.Gopalakrishnan@amd.com>,
        Andre Przywara <andre@andrep.de>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andreas <linuxuser330250@gmx.net>
Subject: Re: [PATCH] powernow-k8: Add a kconfig dependency on acpi-cpufreq
Message-ID: <20130117221240.GA4122@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	"Gopalakrishnan, Aravind" <Aravind.Gopalakrishnan@amd.com>,
	Andre Przywara <andre@andrep.de>,
	"cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
	"linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Andreas <linuxuser330250@gmx.net>
References: <1357780161-30581-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
 <7359167.GTsCEtNASI@vostro.rjw.lan>
 <20130117141758.GA3386@pd.tnic>
 <3845649.nP3d3cdOBJ@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3845649.nP3d3cdOBJ@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 11:10:56PM +0100, Rafael J. Wysocki wrote:
> 3.7+ I suppose?

Yes, the patch adding the request_module() call went in in 3.7:

$ git tag --contains e1f0b8e9b04a2
v3.7
v3.7-rc1
v3.7-rc2
v3.7-rc3
v3.7-rc4
v3.7-rc5
v3.7-rc6
v3.7-rc7
v3.7-rc8
v3.7.1
v3.8-rc1
v3.8-rc2
v3.8-rc3
$

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
