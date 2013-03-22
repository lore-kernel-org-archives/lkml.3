Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933272Ab3CVJaj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 05:30:39 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:55198 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933012Ab3CVJah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 05:30:37 -0400
Date: Fri, 22 Mar 2013 09:30:27 +0000
From: Andrew Murray <andrew.murray@arm.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 0/2] PCI: Introduce MSI chip infrastructure
Message-ID: <20130322093027.GA521@arm.com>
References: <1363942307-9327-1-git-send-email-thierry.reding@avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1363942307-9327-1-git-send-email-thierry.reding@avionic-design.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22, 2013 at 08:51:45AM +0000, Thierry Reding wrote:
> It
> is the responsibility of the PCI host bridge driver to setup the MSI
> chip for the root bus.

I think this could work well. In the future if the use of an independent MSI
controller is required, then new DT bindings for host-bridges could use
phandles to reference independent MSI controllers as their providers of
MSIs. I guess this functionality can be built on top of what you have proposed
later as the need arises.

Andrew Murray
