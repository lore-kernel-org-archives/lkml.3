Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490Ab3HCQqe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 12:46:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49093 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417Ab3HCQqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 12:46:32 -0400
Date: Sat, 3 Aug 2013 18:41:03 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Zach Levis <zml@linux.vnet.ibm.com>
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        dan.carpenter@oracle.com, Zach Levis <zach@zachsthings.com>
Subject: Re: [PATCH v3 1/3] fs/binfmts: Add a name field to the binfmt
	struct
Message-ID: <20130803164103.GA32568@redhat.com>
References: <1374766845-13565-1-git-send-email-zml@linux.vnet.ibm.com> <1375485703-4077-2-git-send-email-zml@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375485703-4077-2-git-send-email-zml@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02, Zach Levis wrote:
>
>  static struct linux_binfmt elf_format = {
> +	.name		= "ELF",

Once again, I think it would be better if elf_format and compat_elf_format
have the different names. But with this patch they are both "ELF".

Oleg.

