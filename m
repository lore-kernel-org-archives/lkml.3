Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033Ab3KCSOf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 13:14:35 -0500
Received: from mout.gmx.net ([212.227.15.15]:55560 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926Ab3KCSOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 13:14:34 -0500
Date: Sun, 3 Nov 2013 19:14:28 +0100
From: Andreas Werner <wernerandy@gmx.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, bp@alien8.de
Subject: Re: [PATCH v2] X86: MM: Add PAT Type write-through in combination
 with mtrr
Message-ID: <20131103181427.GA1346@thinkpad.fritz.box>
References: <1383480142-5665-1-git-send-email-wernerandy@gmx.de>
 <52768B8E.1060902@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52768B8E.1060902@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V03:K0:sXqMz1odnuUToTzKciURwFioSOGe65fyVjpja28o/9dt9qOv/6+
 0pE2oXya/fVPrTFgPtQy16EUAembfxC7l/8SxqjcaDpeLpSag24xQ3pgeCY4L8ScTCcxEOg
 THOEHEKPe//t5HptAX/KZOy+2yjv8hcBbNVZNHN7Rs7wMY71Gkc7wxITAdAKZnbWt56neBs
 WojEBfYGEwk9khJj4a4bg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 03, 2013 at 09:44:46AM -0800, H. Peter Anvin wrote:
> On 11/03/2013 04:02 AM, Andreas Werner wrote:
> > 
> > Since marking IO Memory as cachable is not valid, WT is the
> > best way for caching/bursting on MMIO Devices.
> > 
> 
> Uh... WT *is* cachable...
> 
> 	-hpa
> 
> 

Sorry my mistake, i mean "marking IO Memory as WB is not valid"

regards 
Andy
