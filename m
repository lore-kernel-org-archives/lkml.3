Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567Ab3CIUtR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 15:49:17 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:35180 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751194Ab3CIUtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 15:49:16 -0500
X-Sasl-enc: 8Y5QoIvizccFIZTnrGIpMVuKo/OF/6d9jQ4mMSR/pMjm 1362862155
Date: Sat, 9 Mar 2013 17:49:13 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@alien8.de>, Yves-Alexis Perez <corsac@debian.org>,
        ibm-acpi-devel@lists.sourceforge.net,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [ibm-acpi-devel] x230: unhandled HKEY event 0x6050
Message-ID: <20130309204913.GA7559@khazad-dum.debian.net>
References: <20130304213804.GE22274@pd.tnic>
 <20130307003016.GA21655@khazad-dum.debian.net>
 <1362816406.19016.16.camel@scapa>
 <20130309113631.GA18133@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130309113631.GA18133@pd.tnic>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 09 Mar 2013, Borislav Petkov wrote:
> On Sat, Mar 09, 2013 at 09:06:46AM +0100, Yves-Alexis Perez wrote:
> > Also see https://bugzilla.kernel.org/show_bug.cgi?id=51231 and
> > https://patchwork.kernel.org/patch/2124861/
> 
> Great, another fit-the-hardware-to-the-software idiocy because those
> dimwits which call their pile of stinking software running in ring 0 the
> parts of a house want to control every-f*cking-thing. Sigh :(.
> 
> Thanks for the links Yves-Alexis, certainly a sad read.

Hmm, I don't follow.  thinkpad-acpi does run on ring 0, so was that aimed at
me?  Or are you complaining about the Win-8 bug-to-bug compatibility madness
Lenovo added to the ACPI firmware?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
