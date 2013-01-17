Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab3AQWFF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 17:05:05 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:43905 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753698Ab3AQWFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 17:05:03 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Borislav Petkov <bp@alien8.de>
Cc: "Gopalakrishnan, Aravind" <Aravind.Gopalakrishnan@amd.com>,
        Andre Przywara <andre@andrep.de>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andreas <linuxuser330250@gmx.net>
Subject: Re: [PATCH] powernow-k8: Add a kconfig dependency on acpi-cpufreq
Date: Thu, 17 Jan 2013 23:10:56 +0100
Message-ID: <3845649.nP3d3cdOBJ@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130117141758.GA3386@pd.tnic>
References: <1357780161-30581-1-git-send-email-Aravind.Gopalakrishnan@amd.com> <7359167.GTsCEtNASI@vostro.rjw.lan> <20130117141758.GA3386@pd.tnic>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 17, 2013 03:17:58 PM Borislav Petkov wrote:
> On Thu, Jan 17, 2013 at 01:53:55PM +0100, Rafael J. Wysocki wrote:
> > Do we need that in -stable?
> 
> Yes, please.

3.7+ I suppose?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
