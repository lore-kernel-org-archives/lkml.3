Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946AbaDCRDa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 13:03:30 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:43698 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752787AbaDCRDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 13:03:23 -0400
X-Sasl-enc: JxWNuHZJasKE+e9SBkq9fYQrGhGmOYnO51NIFBBU7rQg 1396544594
Date: Thu, 3 Apr 2014 14:03:08 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Shuduo Sang <shuduo.sang@canonical.com>
Cc: matthew.garrett@nebula.com, ibm-acpi@hmh.eng.br,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org,
        ibm-acpi-devel@lists.sourceforge.net,
        Bruce Ma <bruce.ma@canonical.com>
Subject: Re: [ibm-acpi-devel] [PATCH] support thinkpad HKEY interface version
 0x200
Message-ID: <20140403170308.GC14936@khazad-dum.debian.net>
References: <531F0073.7060103@canonical.com>
 <20140403154427.GB32027@khazad-dum.debian.net>
 <CA+BAWBQcu4KBG3hmuqBMmWeqE1k9itgXyDtMRibZZOLvvAdwHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+BAWBQcu4KBG3hmuqBMmWeqE1k9itgXyDtMRibZZOLvvAdwHQ@mail.gmail.com>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 Apr 2014, Shuduo Sang wrote:
> On Thu, Apr 3, 2014 at 11:44 PM, Henrique de Moraes Holschuh <hmh@hmh.eng.br
> > wrote:
> 
> > On Tue, 11 Mar 2014, Shuduo Sang wrote:
> > > Please kindly review following patch. It support new BIOS which shiped
> > > with Thinkpad X1 Carbon 2nd generation. Without it, hotkey mask be
> > > routed to wrong branch and some hot key will not work.
> >
> > Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> >
> > Can you guys get documentation on the new mode from Lenovo?
> >
> 
> Yes, actually it's a joint-effort to officially enable X1 carbon 2nd
> generation by Canonical and Lenovo.

Ok. Feel free to contact me over private email if required.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
