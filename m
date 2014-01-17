Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663AbaAQAVb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 19:21:31 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:52017 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751047AbaAQAV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 19:21:29 -0500
X-Sasl-enc: 1NGHfLtkNbMpGpmlUymciXcjbOovTwkJ4qU3GlflNTyn 1389918088
Date: Thu, 16 Jan 2014 22:21:24 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
Cc: Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Kim Naru <kim.naru@amd.com>, Sherry Hurwitz <sherry.hurwitz@amd.com>
Subject: Re: [PATCH] x86, CPU, AMD: Add workaround for family 16h, erratum 793
Message-ID: <20140117002123.GA9165@khazad-dum.debian.net>
References: <20140114114133.GA31473@khazad-dum.debian.net>
 <20140114115547.GA29887@pd.tnic>
 <52D55468.6000000@zytor.com>
 <20140114153534.GE29865@pd.tnic>
 <20140114162722.GF29865@pd.tnic>
 <52D59ACC.3090100@amd.com>
 <20140114203848.GP29865@pd.tnic>
 <52D81DB5.7000608@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D81DB5.7000608@amd.com>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jan 2014, Aravind Gopalakrishnan wrote:
> We might want to still have a software fix for this just in case
> someone uses older BIOSes..

There is no "just in case" when it comes to someone using outdated firmware.
It is a *given*, except for hardware that is only used in HPC and multiple
(> 2) socket servers/workstations (which might be the case here, I don't
know what processors we're talking about).

The vast majority of PC users will never update their firmware, unless the
update is automatically offered to them, and sometimes not even in that
case.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
