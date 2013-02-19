Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933074Ab3BSRKZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 12:10:25 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:60994 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933012Ab3BSRKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 12:10:21 -0500
Message-ID: <5123B1F8.4040102@wwwdotorg.org>
Date: Tue, 19 Feb 2013 10:10:16 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: Hiroshi Doyu <hdoyu@nvidia.com>, linux-tegra@vger.kernel.org,
        pdeschrijver@nvidia.com, pgaikwad@nvidia.com,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>, Simon Glass <sjg@chromium.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [v3 0/6] ARM: tegra: convert device tree files to use CLK defines
References: <1360917814-27236-1-git-send-email-hdoyu@nvidia.com> <1361138717.29465.2@driftwood>
In-Reply-To: <1361138717.29465.2@driftwood>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2013 03:05 PM, Rob Landley wrote:
> On 02/15/2013 02:43:11 AM, Hiroshi Doyu wrote:
>> Hi,
>>
>> With new dtc+cpp feature, we could get rid of magic numbers in dts*
>> files. This patch replaces CLK IDs.
>>
>> We also plan to share those DT header files with kernel source
>> later[1].
> ...
>> [1]
>> http://lists.infradead.org/pipermail/linux-arm-kernel/2013-February/149804.html
>>
> 
> This really smells like documentation should be updated, probably
> booting-without-of.txt or similar. Alas, I'm not capable of writing such
> an update...

I'm not sure what documentation would be updated nor why. Can you
describe that?

This patch is (or should be) editing the device tree binding
documentation to (include by) reference the header file that is being
added in this patch. I don't believe there's any more general
documentation that is affected by this series.
