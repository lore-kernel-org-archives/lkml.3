Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619Ab3ISRtt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 13:49:49 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:56218 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab3ISRtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 13:49:47 -0400
Message-ID: <523B3935.2090904@wwwdotorg.org>
Date: Thu, 19 Sep 2013 11:49:41 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: David Gibson <david@gibson.dropbear.id.au>
CC: Jon Loeliger <jdl@jdl.com>, Olof Johansson <olof@lixom.net>,
        frowand.list@gmail.com, Tomasz Figa <tomasz.figa@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [dtc PATCH] Ensure all tests have matching reg and unit address
References: <1379535782-12667-1-git-send-email-swarren@wwwdotorg.org> <20130919121818.GB3551@voom.redhat.com>
In-Reply-To: <20130919121818.GB3551@voom.redhat.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2013 06:18 AM, David Gibson wrote:
> On Wed, Sep 18, 2013 at 02:23:02PM -0600, Stephen Warren wrote:
>> From: Stephen Warren <swarren@nvidia.com>
>> 
>> ePAPR 1.1 section 2.2.1.1 "Node Name Requirements" specifies that
>> any node that has a reg property must include a unit address in
>> its name with value matching the first entry in its reg property.
>> Conversely, if a node does not have a reg property, the node name
>> must not include a unit address.
>> 
>> Adjust all the dtc test-cases to conform to this rule.
>> 
>> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> 
> Yeah, the testcase examples were built as purely syntactic
> exercises without really considering dt content conventions.
> Fixing them up is arguably unnnecessary, but certainly doesn't hurt
> and makes them better as examples.
> 
> Applied and pushed.

Strange; I see that the git author field ended up as you rather than
me. Did you need to apply the patch manually for some reason (if so,
what did I do wrong?) or did something go wrong in the patch
application process?
