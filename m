Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347Ab3HUGaM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 02:30:12 -0400
Received: from ozlabs.org ([203.10.76.45]:35263 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752257Ab3HUGaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 02:30:07 -0400
Message-ID: <52145E6C.80404@ozlabs.org>
Date: Wed, 21 Aug 2013 14:30:04 +0800
From: Jeremy Kerr <jk@ozlabs.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Dwight Engen <dwight.engen@oracle.com>
CC: Arnd Bergmann <arnd@arndb.de>, cbe-oss-dev@lists.ozlabs.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>,
        linux-next@vger.kernel.org, Gao feng <gaofeng@cn.fujitsu.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: linux-next: build failure after merge of the final tree
References: <20130820172052.1f0d89ddf6a1a40ef70333fd@canb.auug.org.au> <20130820120702.000b044e@oracle.com> <201308202246.30869.arnd@arndb.de> <20130821010822.220f592a@oracle.com>
In-Reply-To: <20130821010822.220f592a@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

> Yes, I agree. The other filesystems that take an Opt_uid as well do use
> current_user_ns() and not init_user_ns. They also do a uid_valid()
> check and fail the mount (or fallback to GLOBAL_ROOT_UID). So I think
> that would look like this:

Looks good to me. Builds and mounts as expected.

Acked-by: Jeremy Kerr <jk@ozlabs.org>

Cheers,


Jeremy

