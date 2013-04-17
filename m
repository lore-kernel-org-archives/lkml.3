Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965917Ab3DQKRf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 06:17:35 -0400
Received: from multi.imgtec.com ([194.200.65.239]:51670 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965778Ab3DQKRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 06:17:34 -0400
Message-ID: <516E76A5.4090805@imgtec.com>
Date: Wed, 17 Apr 2013 11:17:09 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Alexander Viro <viro@zeniv.linux.org.uk>
CC: James Hogan <james.hogan@imgtec.com>, <linux-kernel@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v7] fs: imgdafs: Add IMG DAFS filesystem for metag
References: <1364382479-15814-1-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1364382479-15814-1-git-send-email-james.hogan@imgtec.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_04_17_11_17_33
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

On 27/03/13 11:07, James Hogan wrote:
> Add the IMG Debug Adapter File System (DAFS) for metag, which uses
> SWITCH operations to communicate with a file server on a host computer
> via a JTAG debug adapter.
> 
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> ---
> v7:
>   * use explicit sized types in da_stat and da_finddata (Al Viro)
>   * move IMGDAFS_SUPER_MAGIC to <linux/magic.h> (Al Viro)
>   * use fmode_t instead of int in a couple of places (Al Viro)
>   * removed "will unlock" comment (Al Viro)
>   * use kmalloc and init hi->mode explicitly (Al Viro)
>   * kmalloc instead of using dynamic array for path (Al Viro)
>   * use file_inode() helper in dafs_readdir (Al Viro)

Does this latest version look okay for v3.10?

Cheers
James

