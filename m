Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299AbbAVVzx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 16:55:53 -0500
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:49161 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940AbbAVVzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 16:55:51 -0500
Date: Thu, 22 Jan 2015 23:55:43 +0200
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: David Daney <ddaney@caviumnetworks.com>
Cc: Mark Rutland <mark.rutland@arm.com>, David Daney <ddaney.cavm@gmail.com>,
        Aleksey Makarov <aleksey.makarov@auriga.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Daney <david.daney@cavium.com>,
        Anton Vorontsov <avorontsov@ru.mvista.com>,
        Vinita Gupta <vgupta@caviumnetworks.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Ralf Baechle <ralf@linux-mips.org>,
        Tejun Heo <tj@kernel.org>, Hans de Goede <hdegoede@redhat.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH] SATA: OCTEON: support SATA on OCTEON platform
Message-ID: <20150122215543.GA5048@fuloong-minipc.musicnaut.iki.fi>
References: <1421681040-3392-1-git-send-email-aleksey.makarov@auriga.com>
 <20150119154357.GH21553@leverpostej>
 <54BD580C.6030701@gmail.com>
 <20150121165427.GA8722@leverpostej>
 <54BFDF2B.80708@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54BFDF2B.80708@caviumnetworks.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jan 21, 2015 at 09:17:31AM -0800, David Daney wrote:
> On 01/21/2015 08:54 AM, Mark Rutland wrote:
> >While the DTB may already exist, the string "cavium,octeon-7130-ahci"
> >isn't in mainline, and as far as I can see has never been supported.
> 
> There seems to be a disconnect here.  The DTB comes from the hardware boot
> environment.  The hardware is in some cases already deployed.  It is for all
> practical purposes, impossible to change the DTB.

It's possible to change/fix the DTB in platform code like currently
done for the OCTEON in-tree DTBs. But that's ugly.

I think there should be also a mechanism to override the DTB completely
with a user supplied one like with kernel APPENDED_DTB on ARM.

A.
