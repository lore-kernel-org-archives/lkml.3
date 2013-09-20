Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438Ab3ITJGN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 05:06:13 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:41312 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754413Ab3ITJGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 05:06:11 -0400
Date: Fri, 20 Sep 2013 10:06:04 +0100
From: Matt Fleming <matt@console-pimps.org>
To: jerry.hoemann@hp.com
Cc: Andrew Fish <afish@apple.com>, Laszlo Ersek <lersek@redhat.com>,
        linux-efi@vger.kernel.org, Gleb Natapov <gleb@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Brian Richardson <brian.richardson@intel.com>,
        Colin Ian King <colin.king@canonical.com>,
        Randy Wright <rwright@hp.com>, Linn Crosetto <linn.crosetto@hp.com>,
        terry.lee@hp.com, samer.el-haj-mahmoud@hp.com, randy.pawell@hp.com,
        chrisp@hp.com, linda.knippers@hp.com, dong.wei@hp.com,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        kexec <kexec@lists.infradead.org>
Subject: Re: [edk2] Corrupted EFI region
Message-ID: <20130920090604.GB4785@console-pimps.org>
References: <20130806141036.GD14891@pd.tnic>
 <520116D1.2010000@redhat.com>
 <20130807151935.GJ17920@pd.tnic>
 <CCFD3CBD-62B0-4046-B96D-18CB1A815F72@apple.com>
 <20130807201908.GG2515@console-pimps.org>
 <D5982201-6DC4-469F-812A-74A8402ADEE9@apple.com>
 <20130808101730.GJ2515@console-pimps.org>
 <20130913203812.GA312@anatevka.fc.hp.com>
 <20130916105920.GB2697@console-pimps.org>
 <20130918192414.GB3345@anatevka.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130918192414.GB3345@anatevka.fc.hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Sep, at 01:24:14PM, jerry.hoemann@hp.com wrote:
> Matt,
> 
> I conducted the following experiments on a 3.11 kernel:
 
Jerry, could you paste your memory map from the kernel log?

-- 
Matt Fleming, Intel Open Source Technology Center
