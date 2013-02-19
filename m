Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932947Ab3BSRIX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 12:08:23 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:34967 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756731Ab3BSRIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 12:08:21 -0500
Message-ID: <5123B180.5060106@wwwdotorg.org>
Date: Tue, 19 Feb 2013 10:08:16 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Simon Glass <sjg@chromium.org>
CC: Hiroshi Doyu <hdoyu@nvidia.com>, linux-tegra@vger.kernel.org,
        pdeschrijver@nvidia.com, pgaikwad@nvidia.com,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [v3 0/6] ARM: tegra: convert device tree files to use CLK defines
References: <1360917814-27236-1-git-send-email-hdoyu@nvidia.com> <CAPnjgZ0Bkk0Ock5_WQxsni+qNMQnWURrLLqfNFVfKczN6OgLoQ@mail.gmail.com>
In-Reply-To: <CAPnjgZ0Bkk0Ock5_WQxsni+qNMQnWURrLLqfNFVfKczN6OgLoQ@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2013 03:20 PM, Simon Glass wrote:
> Hi Hiroshi,
> 
> On Fri, Feb 15, 2013 at 12:43 AM, Hiroshi Doyu <hdoyu@nvidia.com> wrote:
>> Hi,
>>
>> With new dtc+cpp feature, we could get rid of magic numbers in dts*
>> files. This patch replaces CLK IDs.
...
> I wonder what sort of error message do you get when you make a mistake
> in the .dts or one of the .dtsi includes? If cpp is handling the
> including, does dtc just see a single file,

It is.

> in which case are the line
> numbers printed with each error not much use? Or does dtc handle the
> #line directives?

cpp does generate #line directives, which dtc does know how to
interpret, so this should all work just fine. IIRC, I did test out this
aspect when adding #line support to dtc.
