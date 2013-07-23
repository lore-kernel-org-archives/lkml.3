Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934247Ab3GWUTy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 16:19:54 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:51185 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933706Ab3GWUTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 16:19:51 -0400
Date: Tue, 23 Jul 2013 17:19:42 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Tushar Behera <tushar.behera@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>, patches@linaro.org,
        sachin.kamat@linaro.org,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH V2 6/6] pci: mvebu: Convert to use devm_ioremap_resource
Message-ID: <20130723201941.GB11373@localhost>
References: <1370864113-17895-14-git-send-email-tushar.behera@linaro.org>
 <1371460573-30004-1-git-send-email-tushar.behera@linaro.org>
 <CAErSpo7hHSmO6euUtJABLB-xeK9u+J2h6z905e5DrcZv5gZoEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAErSpo7hHSmO6euUtJABLB-xeK9u+J2h6z905e5DrcZv5gZoEA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 12:38:28PM -0600, Bjorn Helgaas wrote:
> [+cc Thomas]
> 
> On Mon, Jun 17, 2013 at 3:16 AM, Tushar Behera <tushar.behera@linaro.org> wrote:
> > Commit 75096579c3ac ("lib: devres: Introduce devm_ioremap_resource()")
> > introduced devm_ioremap_resource() and deprecated the use of
> > devm_request_and_ioremap().
> >
> > While at it, modify mvebu_pcie_map_registers() to propagate error code.
> >
> > Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> > CC: linux-pci@vger.kernel.org
> > CC: Bjorn Helgaas <bhelgaas@google.com>
> 
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> 

Acked-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>A

> Thomas has a bunch of mvebu patches in the pipeline, so I assume he
> will incorporate this if appropriate.  I don't want to put it in my
> tree and cause conflicts with his changes.  Let me know if I should do
> something else here.
> 

We have the MBus DT patches, to say the least.
Not sure if it conflicts with this and how we should handle it in that
case.

Jason, any ideas?
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
