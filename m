Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762756Ab3IDOOM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 10:14:12 -0400
Received: from a10-13.smtp-out.amazonses.com ([54.240.10.13]:60505 "EHLO
	a10-13.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755476Ab3IDOOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 10:14:10 -0400
Date: Wed, 4 Sep 2013 14:14:08 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
cc: Tejun Heo <tj@kernel.org>,
        "akpm@linuxfoundation.org" <akpm@linuxfoundation.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Steven Rostedt <srostedt@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [gcv v3 32/35] arc: Replace __get_cpu_var uses
In-Reply-To: <5226E55A.3000705@synopsys.com>
Message-ID: <00000140e952bc1f-25743208-6728-4ded-b110-9ded0321f723-000000@email.amazonses.com>
References: <20130828193457.140443630@linux.com> <00000140c6781cab-d0df0392-b65b-4213-8be0-1e4a04f67fb2-000000@email.amazonses.com> <C2D7FE5348E1B147BCA15975FBA23075140F60@IN01WEMBXA.internal.synopsys.com> <00000140caf51d3b-0c5ebca6-f4a7-49b8-94c8-fc8b0bde04b8-000000@email.amazonses.com>
 <5226E55A.3000705@synopsys.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.09.04-54.240.10.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Sep 2013, Vineet Gupta wrote:

> Considering other discussions on this thread, shall I drop this from my for-curr
> for this merge window ? I don't see any other arch changes to that effect in
> latest linux-next.

The required fix of the macros was merged yesterday into upstream.

