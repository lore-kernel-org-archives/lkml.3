Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609Ab3HTSxi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 14:53:38 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:52790 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab3HTSxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 14:53:36 -0400
Message-ID: <5213BB2C.60908@wwwdotorg.org>
Date: Tue, 20 Aug 2013 12:53:32 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Julia Lawall <julia.lawall@lip6.fr>,
        Thierry Reding <thierry.reding@gmail.com>,
        kernel-janitors@vger.kernel.org,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/7] PCI: tegra: replace devm_request_and_ioremap by devm_ioremap_resource
References: <1376911241-27720-1-git-send-email-Julia.Lawall@lip6.fr> <1376911241-27720-2-git-send-email-Julia.Lawall@lip6.fr> <20130819120249.GA5740@ulmo> <alpine.DEB.2.02.1308191405450.2313@hadrien> <20130819121238.GB5740@ulmo> <alpine.DEB.2.02.1308191414360.2313@hadrien> <20130819193339.GB4961@mithrandir> <alpine.DEB.2.02.1308201112400.2269@hadrien> <CAErSpo4WLt7zbyfkKfvMbXMQGmp0MAS=7AFiomUjtUCfdprDUA@mail.gmail.com>
In-Reply-To: <CAErSpo4WLt7zbyfkKfvMbXMQGmp0MAS=7AFiomUjtUCfdprDUA@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2013 10:26 AM, Bjorn Helgaas wrote:
> On Tue, Aug 20, 2013 at 3:13 AM, Julia Lawall <julia.lawall@lip6.fr> wrote:
>> From: Julia Lawall <Julia.Lawall@lip6.fr>
>>
>> Use devm_ioremap_resource instead of devm_request_and_ioremap.
>>
>> This was done using the semantic patch
>> scripts/coccinelle/api/devm_ioremap_resource.cocci
>>
>> Error-handling code was manually removed from the associated calls to
>> platform_get_resource.
>>
>> Adjust the comment at the third platform_get_resource_byname to make clear
>> why ioremap is not done at this point.
>>
>> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>> Acked-by: Thierry Reding <thierry.reding@gmail.com>
>> Tested-by: Thierry Reding <thierry.reding@gmail.com>
> 
> I'm hoping this goes via arm-soc.  Let me know if you need me to do
> something.  If you need it:
> 
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>

In that case, Thierry, can you please bounce it to arm@kernel.org to be
applied on top of wherever Tegra's for-3.12/soc branch was merged.

Acked-by: Stephen Warren <swarren@nvidia.com>
