Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbbAURlI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 12:41:08 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:45452 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbbAURlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 12:41:04 -0500
Message-ID: <54BFE4AC.5010609@kernel.dk>
Date: Wed, 21 Jan 2015 10:41:00 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: green@linuxhacker.ru, Stephen Rothwell <sfr@canb.auug.org.au>,
        Greg KH <greg@kroah.com>
CC: linux-next@vger.kernel.org,
        "<linux-kernel@vger.kernel.org> Mailing List" 
	<linux-kernel@vger.kernel.org>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] staging/lustre/llite: get rid of backing_dev_info
References: <20150121144558.79cb2056@canb.auug.org.au> <1421827847-8371-1-git-send-email-green@linuxhacker.ru>
In-Reply-To: <1421827847-8371-1-git-send-email-green@linuxhacker.ru>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2015 01:10 AM, green@linuxhacker.ru wrote:
> From: Oleg Drokin <green@linuxhacker.ru>
>
> With removal of backing_dev_info from struct address_space,
> we don't need to assign it in Lustre either.

Thanks Oleg, applied. Stephen, you should be able to drop the BROKEN 
lustre patch again.

-- 
Jens Axboe

