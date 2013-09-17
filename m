Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027Ab3IQFGF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 01:06:05 -0400
Received: from ozlabs.org ([203.10.76.45]:58018 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698Ab3IQFGC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 01:06:02 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Julia Lawall <julia.lawall@lip6.fr>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>
Subject: Re: Please add PTR_RET tree.
In-Reply-To: <20130715173826.f698f36373c6f701126b42d3@canb.auug.org.au>
References: <8738rg30cw.fsf@rustcorp.com.au> <20130715173826.f698f36373c6f701126b42d3@canb.auug.org.au>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Tue, 17 Sep 2013 10:20:55 +0930
Message-ID: <87y56wz2xc.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:
> Hi Rusty,
>
> On Mon, 15 Jul 2013 14:07:03 +0930 Rusty Russell <rusty@rustcorp.com.au> wrote:
>>
>> Temporary branch for PTR_RET -> PTR_ERR_OR_ZERO and associated cleanups.
>> 
>>         git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux.git PTR_RET
>> 
>> Log appended.  Contributors and people who didn't already ack CC'd.
>
> Added from tomorrow.

Please remove PTR_RET tree, it's merged.

Cheers,
Rusty.
