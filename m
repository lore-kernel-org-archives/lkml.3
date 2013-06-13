Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759273Ab3FMW4M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 18:56:12 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:37955 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970Ab3FMW4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 18:56:11 -0400
Message-ID: <51BA4E07.7060001@wwwdotorg.org>
Date: Thu, 13 Jun 2013 16:56:07 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Grant Likely <grant.likely@linaro.org>,
        Stephen Warren <SWarren@nvidia.com>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [GIT PULL] devicetree bugfixes for v3.10
References: <CACxGe6sE5qm5CmGxO8p1dR9v7bbqipm5pYRz8F6pQdWVHetCgA@mail.gmail.com> <1371163963.5555.25.camel@pasglop>
In-Reply-To: <1371163963.5555.25.camel@pasglop>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2013 04:52 PM, Benjamin Herrenschmidt wrote:
> On Thu, 2013-06-13 at 23:22 +0100, Grant Likely wrote:
>> Grant Likely (2):
>>       dtc: Update generated files to output from Bison 2.5
>>       dtc: ensure #line directives don't consume data from the next 
> 
> Question. Are those fixes also in the upstream dtc from jdl ? Or have we
> effectively forked it ?

Patch 1 just edits generated files which don't exist upstream (the
kernel checks them in, but upstream relies on the user running Bison/...
as part of make).

Patch 2 is a cherry-pick from upstream (plus regenerating some
difference generated files)
