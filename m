Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbaCRNDU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 09:03:20 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:47655 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbaCRNDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 09:03:15 -0400
Message-ID: <53283F14.6070303@gmail.com>
Date: Tue, 18 Mar 2014 13:41:56 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: mtk.manpages@gmail.com,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Andreas Dilger <adilger@dilger.ca>, NeilBrown <neilb@suse.de>
Subject: Re: For review: open_by_name_at(2) man page
References: <53271B69.3000305@gmail.com> <20140318093751.GA8068@infradead.org>
In-Reply-To: <20140318093751.GA8068@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2014 10:37 AM, Christoph Hellwig wrote:
> Hi Michael,
> 
> the man page looks reasonable.  If you refer to openat(2) instead of
> open(2) in the ERRORS section you could avoid duplicating a few of the
> dirfd and flags related errors.

Good idea. Done.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
