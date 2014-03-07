Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011AbaCHFee (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 00:34:34 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:55421 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302AbaCHFaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 00:30:23 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v2 4/4] pci: Add support for creating a generic host_bridge from device tree
To: Arnd Bergmann <arnd@arndb.de>, linaro-kernel@lists.linaro.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LAKML <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <18746655.qWHLpMg2Yy@wuerfel>
References: <1393506402-11474-1-git-send-email-Liviu.Dudau@arm.com> < 1393506402-11474-5-git-send-email-Liviu.Dudau@arm.com> <18746655.qWHLpMg2Yy @wuerfel>
Date: Fri, 07 Mar 2014 18:58:26 +0000
Message-Id: <20140307185826.0DF50C40D6D@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Feb 2014 14:38:32 +0100, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 27 February 2014 13:06:42 Liviu Dudau wrote:
> > Several platforms use a rather generic version of parsing
> > the device tree to find the host bridge ranges. Move the common code
> > into the generic PCI code and use it to create a pci_host_bridge
> > structure that can be used by arch code.
> > 
> > Based on early attempts by Andrew Murray to unify the code.
> > Used powerpc and microblaze PCI code as starting point.
> > 
> > Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> 
> Please add Benjamin Herrenschmidt to Cc here, I think it would be helpful
> to get his input so we can make this work on powerpc as well.

s/helpful/required/

:-)

g.
