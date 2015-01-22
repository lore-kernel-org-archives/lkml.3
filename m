Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbbAVWfl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 17:35:41 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:56812 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753501AbbAVWfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 17:35:39 -0500
From: Stewart Smith <stewart@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Cc: Rob Herring <robh@kernel.org>, open list <linux-kernel@vger.kernel.org>,
        Vasant Hegde <hegdevasant@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Joel Stanley <joel@jms.id.au>,
        Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
        Neelesh Gupta <neelegup@linux.vnet.ibm.com>,
        "open list\:LINUX FOR POWERPC..." <linuxppc-dev@lists.ozlabs.org>,
        Anton Blanchard <anton@samba.org>
Subject: Re: [PATCH v2 2/2] powerpc/powernv: Skip registering log region when CONFIG_PRINTK=n
In-Reply-To: <CAJhHMCDPCdeGSfGFoYcUHXQoemtmSTdsmLrS3_GOewrvNQm8kA@mail.gmail.com>
References: <1421893570-6920-1-git-send-email-bobby.prani@gmail.com> <1421893570-6920-2-git-send-email-bobby.prani@gmail.com> <1421903958.4598.4.camel@ellerman.id.au> <CAJhHMCDPCdeGSfGFoYcUHXQoemtmSTdsmLrS3_GOewrvNQm8kA@mail.gmail.com>
User-Agent: Notmuch/0.18+16~gec02089 (http://notmuchmail.org) Emacs/23.1.1 (x86_64-redhat-linux-gnu)
Date: Fri, 23 Jan 2015 09:35:28 +1100
Message-ID: <m3sif2zbnz.fsf@oc8180480414.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012222-0033-0000-0000-000001A554DF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pranith Kumar <bobby.prani@gmail.com> writes:
> On Thu, Jan 22, 2015 at 12:19 AM, Michael Ellerman <mpe@ellerman.id.au> wrote:
>> On Wed, 2015-01-21 at 21:26 -0500, Pranith Kumar wrote:
>>> When CONFIG_PRINTK=n, log_buf_addr_get() returns NULL and log_buf_len_get()
>>> return 0. Check for these return values and skip registering the dump buffer.
>>>
>>> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
>>> CC: Michael Ellerman <mpe@ellerman.id.au>
>>> ---
>>>  arch/powerpc/platforms/powernv/opal.c | 6 ++++++
>>>  1 file changed, 6 insertions(+)
>>
>> What changed since v1? I don't see anything?
>>
>
> Nothing in this patch but there is a v2 of the first patch in this
> series, so had to resend this patch with a v2.

You also missed my Reviewed-by :)

