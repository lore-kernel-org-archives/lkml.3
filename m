Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab3GJPer (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 11:34:47 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:32839 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587Ab3GJPeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 11:34:44 -0400
Message-ID: <51DD7F10.1040104@acm.org>
Date: Wed, 10 Jul 2013 17:34:40 +0200
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Roland Dreier <roland@kernel.org>
CC: Sebastian Riemer <sebastian.riemer@profitbricks.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [GIT PULL] please pull infiniband.git
References: <1373391385-4978-1-git-send-email-roland@kernel.org> <51DD714D.4080001@profitbricks.com> <CAG4TOxNeJWDWdZv+8nXzE1ektybkTEX0xNYh_S64-Gh4ocTD_A@mail.gmail.com>
In-Reply-To: <CAG4TOxNeJWDWdZv+8nXzE1ektybkTEX0xNYh_S64-Gh4ocTD_A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/13 16:38, Roland Dreier wrote:
> On Wed, Jul 10, 2013 at 7:35 AM, Sebastian Riemer
> <sebastian.riemer@profitbricks.com> wrote:
>>
>> I've checked the commits on that tag and the following commit is not
>> what we've agreed on:
>
> Sorry about that.  The discussion was long and complex and I probably
> made a mistake in aplying the patches.  Please me send a patch to fix
> the driver to what it should be, and I will merge it ASAP.

I will send such a patch in reply to this e-mail but without CC-ing the 
LKML. Sebastian, if you could review that patch, that would be appreciated.

Bart.

