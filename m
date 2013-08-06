Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713Ab3HFSKs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 14:10:48 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:50412 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756652Ab3HFSKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 14:10:45 -0400
MIME-Version: 1.0
In-Reply-To: <20130806123933.2f33828b@skate>
References: <1370864113-17895-14-git-send-email-tushar.behera@linaro.org>
 <1371460573-30004-1-git-send-email-tushar.behera@linaro.org>
 <CAErSpo7hHSmO6euUtJABLB-xeK9u+J2h6z905e5DrcZv5gZoEA@mail.gmail.com> <20130806123933.2f33828b@skate>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 6 Aug 2013 12:10:25 -0600
Message-ID: <CAErSpo6z+3Viex4EmeMhsuS8wfxpZ74QaM=p4Ri3Px3dA26TCQ@mail.gmail.com>
Subject: Re: [PATCH V2 6/6] pci: mvebu: Convert to use devm_ioremap_resource
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Tushar Behera <tushar.behera@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>, patches@linaro.org,
        sachin.kamat@linaro.org,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Jason Cooper <jason@lakedaemon.net>,
        =?ISO-8859-1?Q?Gregory_Cl=E9ment?= 
	<gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 6, 2013 at 4:39 AM, Thomas Petazzoni
<thomas.petazzoni@free-electrons.com> wrote:
> Dear Bjorn Helgaas,
>
> [+cc Jason Cooper, Gregory Clement and Ezequiel Garcia]
>
> On Tue, 23 Jul 2013 12:38:28 -0600, Bjorn Helgaas wrote:
>> [+cc Thomas]
>>
>> On Mon, Jun 17, 2013 at 3:16 AM, Tushar Behera <tushar.behera@linaro.org> wrote:
>> > Commit 75096579c3ac ("lib: devres: Introduce devm_ioremap_resource()")
>> > introduced devm_ioremap_resource() and deprecated the use of
>> > devm_request_and_ioremap().
>> >
>> > While at it, modify mvebu_pcie_map_registers() to propagate error code.
>> >
>> > Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
>> > CC: linux-pci@vger.kernel.org
>> > CC: Bjorn Helgaas <bhelgaas@google.com>
>>
>> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
>>
>> Thomas has a bunch of mvebu patches in the pipeline, so I assume he
>> will incorporate this if appropriate.  I don't want to put it in my
>> tree and cause conflicts with his changes.  Let me know if I should do
>> something else here.
>
> I don't really have that many pci-mvebu.c patches in the pipeline
> actually. The only one I have is to enable MSI support, and it's a
> fairly light one that should not conflict too badly with this one.
>
> Therefore, Bjorn, I believe this patch could go through your tree,
> either for 3.11 or 3.12 as you prefer.

Added to pci/misc for v3.12.  Thanks.

Bjorn
