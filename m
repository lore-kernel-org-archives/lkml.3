Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbaIOOZ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 10:25:56 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:45965 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143AbaIOOZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 10:25:51 -0400
Message-ID: <5416F6CC.3050203@converseincode.com>
Date: Mon, 15 Sep 2014 07:25:16 -0700
From: Behan Webster <behanw@converseincode.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Alasdair G Kergon <agk@redhat.com>, Chris Mason <clm@fb.com>,
        David Miller <davem@davemloft.net>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        Fabian Frederick <fabf@skynet.be>,
        Herbert Xu <herbert@gondor.apana.org.au>, Josef Bacik <jbacik@fb.com>,
        Mike Snitzer <snitzer@redhat.com>, tadeusz.struk@intel.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Dmitry Kasatkin <d.kasatkin@samsung.com>,
        James Morris <james.l.morris@oracle.com>, john.griffin@intel.com,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-ima-devel@lists.sourceforge.net,
        linux-ima-user@lists.sourceforge.net,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Neil Brown <neilb@suse.de>, qat-linux@intel.com,
        "Serge E. Hallyn" <serge@hallyn.com>, thomas.lendacky@amd.com,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v3 11/12] security, crypto: LLVMLinux: Remove VLAIS from
 ima_crypto.c
References: <1410766234-1634-1-git-send-email-behanw@converseincode.com>	<1410766234-1634-12-git-send-email-behanw@converseincode.com> <CA+55aFx8FN2Rq+d3v9rsDbTyX3hwm6TvudvZrL5wgf7fX3aQjA@mail.gmail.com>
In-Reply-To: <CA+55aFx8FN2Rq+d3v9rsDbTyX3hwm6TvudvZrL5wgf7fX3aQjA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/14 07:21, Linus Torvalds wrote:
> On Mon, Sep 15, 2014 at 12:30 AM,  <behanw@converseincode.com> wrote:
>> From: Behan Webster <behanw@converseincode.com>
>>
>> Replaced the use of a Variable Length Array In Struct (VLAIS) with a C99
>> compliant equivalent. This patch allocates the appropriate amount of memory
>> using a char array using the SHASH_DESC_ON_STACK macro.
> You only made the first case use SHASH_DESC_ON_STACK, the two other
> cases you left in the ugly format. Was that just an oversight, or was
> there some reason for it?
>
Oversight. Will Fix.

Behan

-- 
Behan Webster
behanw@converseincode.com

