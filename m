Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832Ab3H1NCk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 09:02:40 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:56935 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896Ab3H1NCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 09:02:37 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo461H=3qD5Xb7rKkMcQ1_ipyAQ5Tv2VhZD4j578A+Bd9w@mail.gmail.com>
References: <1376911241-27720-1-git-send-email-Julia.Lawall@lip6.fr>
 <1376911241-27720-2-git-send-email-Julia.Lawall@lip6.fr> <20130819120249.GA5740@ulmo>
 <CAErSpo5oOnfhi+aRi-Z3kCwS1VpYSO6FX5O_MOZmWNLcfhhA9w@mail.gmail.com>
 <20130819201224.GC5191@mithrandir> <CAErSpo6U9i16gdaYGpWqgLaFteXpy1erCUw55SqkHLcbypP=vA@mail.gmail.com>
 <20130827081443.GI8686@ulmo> <521CCF9B.9000004@wwwdotorg.org> <CAErSpo461H=3qD5Xb7rKkMcQ1_ipyAQ5Tv2VhZD4j578A+Bd9w@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 28 Aug 2013 07:02:16 -0600
Message-ID: <CAErSpo5LOig3KPGfyWJ1BWA61Ox3cyrguSo_XdVqw6SqxttXeA@mail.gmail.com>
Subject: Re: [PATCH 1/7] PCI: tegra: replace devm_request_and_ioremap by devm_ioremap_resource
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>, kernel-janitors@vger.kernel.org,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 12:03 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> On 08/27/2013 02:14 AM, Thierry Reding wrote:

>>> If Stephen's fine with it I suppose we could take pci-tegra.c
>>> driver changes through the Tegra tree. But I think it'd be good if
>>> we could still Cc you on patches so you're aware of what we're
>>> doing (that is the same for all drivers drivers/pci/host/*). And
>>> we're going to need your Acked-by on the patches as well.
>
> I think you have my Acked-by for this case already (from Aug 20).  And
> feel free to copy me on anything you like; my delete key works well :)

I didn't mean for this to sound like "I'll just delete any email you
send me"; I intended more like "feel free to copy me and if it's
something I'm interested or knowledgeable about, I'll try to help and
if not, it's easy for me to ignore it."

Bjorn
