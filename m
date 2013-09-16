Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611Ab3IPQ2H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 12:28:07 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:53533 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab3IPQ2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 12:28:05 -0400
Date: Mon, 16 Sep 2013 17:27:40 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Laszlo Ersek <lersek@redhat.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Matt Fleming <matt@console-pimps.org>, jerry.hoemann@hp.com,
        Andrew Fish <afish@apple.com>, edk2-devel@lists.sourceforge.net,
        linux-efi@vger.kernel.org, Gleb Natapov <gleb@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Richardson <brian.richardson@intel.com>,
        Colin Ian King <colin.king@canonical.com>,
        Randy Wright <rwright@hp.com>, Linn Crosetto <linn.crosetto@hp.com>,
        terry.lee@hp.com, samer.el-haj-mahmoud@hp.com, randy.pawell@hp.com,
        chrisp@hp.com, linda.knippers@hp.com, dong.wei@hp.com,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Chao Zhang <chao.b.zhang@intel.com>, Yao Jiewen <jiewen.yao@intel.com>
Subject: Re: [edk2] Corrupted EFI region
Message-ID: <20130916162739.GA29868@srcf.ucam.org>
References: <20130807151935.GJ17920@pd.tnic>
 <CCFD3CBD-62B0-4046-B96D-18CB1A815F72@apple.com>
 <20130807201908.GG2515@console-pimps.org>
 <D5982201-6DC4-469F-812A-74A8402ADEE9@apple.com>
 <20130808101730.GJ2515@console-pimps.org>
 <20130913203812.GA312@anatevka.fc.hp.com>
 <20130916105920.GB2697@console-pimps.org>
 <5236F096.8040702@redhat.com>
 <20130916155751.GA3636@leaf>
 <523730F2.40408@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <523730F2.40408@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 06:25:22PM +0200, Laszlo Ersek wrote:

> Or are you alluding to UEFI firmware that's not based on TianoCore?

Most BGRT implementations are IBV specific rather than coming from 
Tiano. The ACPI spec says that the image should be stored in 
EfiBootServicesData, and most implementations follow that.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
