Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355AbaHGO7N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 10:59:13 -0400
Received: from cernmx13.cern.ch ([188.184.36.46]:14884 "EHLO CERNMX13.cern.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757335AbaHGO7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 10:59:11 -0400
From: Federico Vaga <federico.vaga@cern.ch>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <michel.arruat@cern.ch>
Subject: Re: PCIe bus enumeration
Date: Thu, 7 Aug 2014 16:59:09 +0200
Message-ID: <1501870.HCbKP9fkqH@pcbe13110.cern.ch>
Organization: CERN
User-Agent: KMail/4.13.3 (Linux/3.15.6-200.fc20.x86_64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <CAErSpo7YEiiM1b8Jf1d3Pt4iZXhwNTr18SsSZS15Ekm_LHS03A@mail.gmail.com>
References: <280883016.9onmf0miLq@pcbe13110.cern.ch> <3107266.EcOOcRPPM0@harkonnen> <CAErSpo7YEiiM1b8Jf1d3Pt4iZXhwNTr18SsSZS15Ekm_LHS03A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [137.138.123.125]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 July 2014 14:27:00 Bjorn Helgaas wrote:
> On Tue, Jul 8, 2014 at 1:20 PM, Federico Vaga 
<federico.vaga@cern.ch> wrote:
> > On Tuesday 08 July 2014 12:23:39 Bjorn Helgaas wrote:
> >> On Tue, Jul 8, 2014 at 1:15 AM, Federico Vaga
> > 
> > <federico.vaga@cern.ch> wrote:
> >> >> > So, It looks like that some BIOS disable the bridge when
> >> >> > there
> >> >> > is
> >> >> > nothing behind it. Why? Power save? :/
> >> >> 
> >> >> Could be power savings, or possibly to conserve bus numbers,
> >> >> which
> >> >> are a limited resource.
> >> > 
> >> > what is the maximum number of buses?
> >> 
> >> 256.
> > 
> > Well, it is not a small number. I will ask directly to the company
> > who sell this crate and ask them what is going on in the BIOS
> 
> Yeah, it's not usually a problem until you get to the really big
> machines.  The BIOS vendor could give you a much better reason; I'm
> only speculating.

Just to complete the discussion (I forgot to do it). The vendor point 
me to the correct BIOS configuration to keep all the PCIe port enable 
even if there is nothing in the slot. Now the bus number enumeration 
seems "constant"

Thank you

-- 
Federico Vaga
