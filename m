Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215Ab3ATOMQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 09:12:16 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:47569 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471Ab3ATOMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 09:12:14 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Borislav Petkov <bp@alien8.de>
Cc: =?ISO-8859-1?Q?Andr=E9?= Przywara <andre@andrep.de>,
        Leonid Isaev <lisaev@umail.iu.edu>, Tom Gundersen <teg@jklm.no>,
        cpufreq@vger.kernel.org, linux-acpi@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 0/6] acpi-cpufreq and powernow-k8 fixes
Date: Sun, 20 Jan 2013 15:18:11 +0100
Message-ID: <1838903.lYvY4Nk4I1@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc4; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1358677470-17394-1-git-send-email-bp@alien8.de>
References: <1358677470-17394-1-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, January 20, 2013 11:24:24 AM Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> Hi all,
> 
> here are a couple of patches fixing acpi-cpufreq and powernow-k8 loading
> sequence and handoff.
> 
> Patch 0001 should be in Rafael's tree already but I'm adding it here for
> the sake of completeness. Basically, we want to address all possible
> cases of powernow-k8 and acpi-cpufreq:
> 
> (M: module, Y: built-in)
> 
> powernow-k8		acpi-cpufreq
> M			M		- powernow-k8 requests acpi-cpufreq
> M			Y		- powernow-k8 sees already loaded acpi-cpufreq
> Y			M		- impossible after patch 0001
> Y			Y		- patches 2,3 fix that
> 
> Anyway, please take a look and let me know.

Well, it all looks reasonable to me.

I suppose you'd like it to go into v3.8 plus v3.7-stable, right?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
