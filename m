Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935115Ab3BNX3O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 18:29:14 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:58526 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935087Ab3BNX3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 18:29:12 -0500
Message-ID: <511D7342.2070205@wwwdotorg.org>
Date: Thu, 14 Feb 2013 16:29:06 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Hiroshi Doyu <hdoyu@nvidia.com>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "sjg@chromium.org" <sjg@chromium.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [v2 1/4] ARM: tegra20: create a DT header defining CLK IDs
References: <1360868369-20093-1-git-send-email-hdoyu@nvidia.com><1360868369-20093-2-git-send-email-hdoyu@nvidia.com><511D45E0.1080105@wwwdotorg.org> <20130214.223422.1106350409475384652.hdoyu@nvidia.com>
In-Reply-To: <20130214.223422.1106350409475384652.hdoyu@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2013 01:34 PM, Hiroshi Doyu wrote:
> Stephen Warren <swarren@wwwdotorg.org> wrote @ Thu, 14 Feb 2013 21:15:28 +0100:
> 
>> Oh, and I don't think you updated e.g. nvidia,tegra20-car.txt to remove
>> the list of clocks.
> 
> Not yet removed. I think that this could be done with the patch which
> allows kernel source to include DT header files.

By defining the header file, you're really causing that header to be
part of the binding definition. I think we should move the code from the
binding .txt file to the header, rather than duplicating it and then
removing it. The kernel doesn't include the binding .txt file right now,
so I don't see any correlation with making it include the header vs.
when we remove the list from the binding document.
