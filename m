Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933318AbaDINuU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 09:50:20 -0400
Received: from webbox1416.server-home.net ([77.236.96.61]:53907 "EHLO
	webbox1416.server-home.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932748AbaDINuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 09:50:18 -0400
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: David Cohen <david.a.cohen@linux.intel.com>, wim@iguana.be,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: intel-mid: add watchdog platform code for Merrifield
Date: Wed, 09 Apr 2014 15:49:05 +0200
Message-ID: <3412449.yg5NtfcPeg@ws-stein>
User-Agent: KMail/4.11.5 (Linux/3.12.13-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140409134223.6444a598@alan.etchedpixels.co.uk>
References: <1396990744-10695-1-git-send-email-david.a.cohen@linux.intel.com> <1396990744-10695-3-git-send-email-david.a.cohen@linux.intel.com> <20140409134223.6444a598@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 April 2014 13:42:23, One Thousand Gnomes wrote:
> On Tue,  8 Apr 2014 13:59:04 -0700
> David Cohen <david.a.cohen@linux.intel.com> wrote:
> 
> > This patch adds platform code for Intel Merrifield.
> > Since the watchdog is not part of SFI table, we have no other option but
> > to manually register watchdog's platform device (argh!).
> 
> Before going too far down that path have you considered compiling in a
> devicetree instead ?

I'm getting curious: How can I use device-tree on x86(_64)?
Reading the dependencies from CONFIG_OF it can only be used on 32bit systems with some special hardware bases.
So, how to use otherwise?

Best regards,
Alexander
-- 
Dipl.-Inf. Alexander Stein

SYS TEC electronic GmbH
Am Windrad 2
08468 Heinsdorfergrund
Tel.: 03765 38600-1156
Fax: 03765 38600-4100
Email: alexander.stein@systec-electronic.com
Website: www.systec-electronic.com
 
Managing Director: Dipl.-Phys. Siegmar Schmidt
Commercial registry: Amtsgericht Chemnitz, HRB 28082

