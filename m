Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933621Ab3HGWGi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 18:06:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54723 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933147Ab3HGWGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 18:06:36 -0400
Message-ID: <5202C4C3.6050007@zytor.com>
Date: Wed, 07 Aug 2013 15:05:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Alessandro Rubini <rubini@gnudd.com>
CC: linux-kernel@vger.kernel.org, ciminaghi@gnudd.com,
        giancarlo.asnaghi@st.com, x86@kernel.org, mingo@redhat.com,
        linux@arm.linux.org.uk, tglx@linutronix.de, devicetree@vger.kernel.org
Subject: Re: [PATCH 00/26] STA2X11 devicetree support for amba/pci
References: <52026AB5.80009@zytor.com>  <cover.1375867291.git.rubini@gnudd.com> <20130807211235.GA17863@mail.gnudd.com>
In-Reply-To: <20130807211235.GA17863@mail.gnudd.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2013 02:12 PM, Alessandro Rubini wrote:
> 
> I understand. My impression of devicetree is exactly like that, I must
> say.  What we have here is a very clean PCI enumeration of it all: we
> only need to specify the mapping of GPIO pins (i.e. card-detect for
> mmc) and DMA channels, as all the rest works by itself.
> 

Could you elucidate this a bit more?  Specifically, from the PCI host's
perspective, how do you know what you are dealing with (presumably PCI
VID:DID:SVID:SID?)  How exactly does the mapping of PCI BARs and
INT/MSI/MSI-X channels to the slave device play in?

I think it is safe to say that the device models we have today simply
don't account for this kind of usage, which, as you say, is a genuine
problem, and I think we need to understand the problem space better in
order to properly architect the solution, as I don't think we have one
right now.

	-hpa

