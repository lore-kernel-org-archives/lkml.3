Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077AbaDGKHZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 06:07:25 -0400
Received: from service87.mimecast.com ([91.220.42.44]:36767 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760AbaDGKHU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 06:07:20 -0400
Date: Mon, 7 Apr 2014 11:07:15 +0100
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci <linux-pci@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v7 4/6] pci: Introduce a domain number for
 pci_host_bridge.
Message-ID: <20140407100715.GI17163@e106497-lin.cambridge.arm.com>
Mail-Followup-To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	linux-pci <linux-pci@vger.kernel.org>,
	Catalin Marinas <Catalin.Marinas@arm.com>,
	Will Deacon <Will.Deacon@arm.com>,
	linaro-kernel <linaro-kernel@lists.linaro.org>,
	Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	LAKML <linux-arm-kernel@lists.infradead.org>,
	Tanmay Inamdar <tinamdar@apm.com>,
	Grant Likely <grant.likely@secretlab.ca>
References: <1394811272-1547-1-git-send-email-Liviu.Dudau@arm.com>
 <1394811272-1547-5-git-send-email-Liviu.Dudau@arm.com>
 <20140405000007.GD15806@google.com>
 <20140407084623.GG17163@e106497-lin.cambridge.arm.com>
 <1396862058.3671.40.camel@pasglop>
MIME-Version: 1.0
In-Reply-To: <1396862058.3671.40.camel@pasglop>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 07 Apr 2014 10:07:32.0325 (UTC) FILETIME=[30E22150:01CF5249]
X-MC-Unique: 114040711071800101
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07, 2014 at 10:14:18AM +0100, Benjamin Herrenschmidt wrote:
> On Mon, 2014-04-07 at 09:46 +0100, Liviu Dudau wrote:
> > 
> > *My* strategy is to get rid of pci_domain_nr(). I don't see why we need
> > to have arch specific way of providing the number, specially after looking
> > at the existing implementations that return a value from a variable that
> > is never touched or incremented. My guess is that pci_domain_nr() was
> > created to work around the fact that there was no domain_nr maintainance in
> > the generic code.
> 
> Well, there was no generic host bridge structure. There is one now, it should
> go there.

Exactly! Hence my patch. After it gets accepted I will go through architectures
and remove their version of pci_domain_nr().

Best regards,
Liviu

> 
> Cheers,
> Ben.
>  
> 
> 

-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯

