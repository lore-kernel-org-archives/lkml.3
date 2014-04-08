Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579AbaDHJuu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 05:50:50 -0400
Received: from service87.mimecast.com ([91.220.42.44]:33971 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756546AbaDHJun convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 05:50:43 -0400
Date: Tue, 8 Apr 2014 10:50:39 +0100
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-pci <linux-pci@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v7 1/6] pci: Introduce pci_register_io_range() helper
 function.
Message-ID: <20140408095038.GT17163@e106497-lin.cambridge.arm.com>
Mail-Followup-To: Bjorn Helgaas <bhelgaas@google.com>,
	Arnd Bergmann <arnd@arndb.de>,
	linux-pci <linux-pci@vger.kernel.org>,
	Catalin Marinas <Catalin.Marinas@arm.com>,
	Will Deacon <Will.Deacon@arm.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	linaro-kernel <linaro-kernel@lists.linaro.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	LAKML <linux-arm-kernel@lists.infradead.org>,
	Tanmay Inamdar <tinamdar@apm.com>,
	Grant Likely <grant.likely@secretlab.ca>
References: <1394811272-1547-1-git-send-email-Liviu.Dudau@arm.com>
 <20140405001953.GE15806@google.com>
 <20140407083120.GE17163@e106497-lin.cambridge.arm.com>
 <5183143.FxBNM0xTAV@wuerfel>
 <CAErSpo4iEV6khP63ZTF+YUTKi9WLFXzMv13nxw15y3qDg15Ztg@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAErSpo4iEV6khP63ZTF+YUTKi9WLFXzMv13nxw15y3qDg15Ztg@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 08 Apr 2014 09:50:55.0655 (UTC) FILETIME=[093C1B70:01CF5310]
X-MC-Unique: 114040810504103701
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07, 2014 at 06:58:24PM +0100, Bjorn Helgaas wrote:
> On Mon, Apr 7, 2014 at 5:36 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> 
> > I think migrating other architectures to use the same code should be
> > a separate effort from adding a generic implementation that can be
> > used by arm64. It's probably a good idea to have patches to convert
> > arm32 and/or microblaze.
> 
> Let me reiterate that I am 100% in favor of replacing arch-specific
> code with more generic implementations.
> 
> However, I am not 100% in favor of doing it as separate efforts
> (although maybe I could be convinced).  The reasons I hesitate are
> that (1) if only one architecture uses a new "generic" implementation,
> we really don't know whether it is generic enough, (2) until I see the
> patches to convert other architectures, I have to assume that I'm the
> one who will write them, and (3) as soon as we add the code to
> drivers/pci, it becomes partly my headache to maintain it, even if
> only one arch benefits from it.
> 
> Please don't think I'm questioning anyone's intent or good will.  It's
> just that I understand the business pressures, and I know how hard it
> can be to justify this sort of work to one's management, especially
> after the immediate problem has been solved.

I understand your concern. I guess the only way to prove my good intentions
is to shut up and show the code.

Liviu

> 
> Bjorn
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

