Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbbAVOfM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 09:35:12 -0500
Received: from mail-vc0-f172.google.com ([209.85.220.172]:36099 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbbAVOfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 09:35:08 -0500
MIME-Version: 1.0
In-Reply-To: <1421903958.4598.4.camel@ellerman.id.au>
References: <1421893570-6920-1-git-send-email-bobby.prani@gmail.com>
 <1421893570-6920-2-git-send-email-bobby.prani@gmail.com> <1421903958.4598.4.camel@ellerman.id.au>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Thu, 22 Jan 2015 09:34:37 -0500
Message-ID: <CAJhHMCDPCdeGSfGFoYcUHXQoemtmSTdsmLrS3_GOewrvNQm8kA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] powerpc/powernv: Skip registering log region when CONFIG_PRINTK=n
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>,
        Neelesh Gupta <neelegup@linux.vnet.ibm.com>,
        Joel Stanley <joel@jms.id.au>,
        Vasant Hegde <hegdevasant@linux.vnet.ibm.com>,
        Rob Herring <robh@kernel.org>,
        "open list:LINUX FOR POWERPC..." <linuxppc-dev@lists.ozlabs.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 12:19 AM, Michael Ellerman <mpe@ellerman.id.au> wrote:
> On Wed, 2015-01-21 at 21:26 -0500, Pranith Kumar wrote:
>> When CONFIG_PRINTK=n, log_buf_addr_get() returns NULL and log_buf_len_get()
>> return 0. Check for these return values and skip registering the dump buffer.
>>
>> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
>> CC: Michael Ellerman <mpe@ellerman.id.au>
>> ---
>>  arch/powerpc/platforms/powernv/opal.c | 6 ++++++
>>  1 file changed, 6 insertions(+)
>
> What changed since v1? I don't see anything?
>

Nothing in this patch but there is a v2 of the first patch in this
series, so had to resend this patch with a v2.

Thanks!
-- 
Pranith
