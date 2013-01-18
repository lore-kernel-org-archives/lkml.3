Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103Ab3AROui (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 09:50:38 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:63551 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890Ab3AROug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 09:50:36 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: Re: [PATCH v2 48/76] ARC: Module support
Date: Fri, 18 Jan 2013 14:50:33 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com> <1358511930-7424-49-git-send-email-vgupta@synopsys.com>
In-Reply-To: <1358511930-7424-49-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301181450.33444.arnd@arndb.de>
X-Provags-ID: V02:K0:WU8w9rchVpXLrdMHbvNiWas7Xn1Wr2xFL6n83bQYPI6
 kjhtRXZ0MRqSnBCz452gZVDnP84XlWTDQYX38GGAaQpWtarMO9
 FUgiCZiTpuTtj4noUiKN9BtSXBGOHSzacrKHX5/XIGmno/hy57
 FPefQxv6k3TTLDz59TXaS0j2SX7kqOMrAL4GKws3cpA6hUHL4T
 i8lAaOMF3CWF7dEDxnRsEmQLpPjvLYfaSgzNkiLOjkLFL8Xkvm
 uQpHpLn/o3MRY1a2aJU7x2tNUsx0DRr0s2WVzMb2C+qxpB32TM
 yaGIxOlMLd1OMQwPnpfHBIdT84MyuksHjsJ46iJk7kFBulPvZn
 d59hbphQ4olLpZJVdKTw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 January 2013, Vineet Gupta wrote:

> +int module_frob_arch_sections(Elf_Ehdr *hdr, Elf_Shdr *sechdrs,
> +			      char *secstr, struct module *mod)
> +{
> +    return 0;
> +}
> +
> +void module_arch_cleanup(struct module *mod)
> +{
> +}
> +
> +int module_finalize(const Elf32_Ehdr *hdr, const Elf_Shdr *sechdrs,
> +		    struct module *mod)
> +{
> +    return 0;
> +}

These three empty functions are already defined __weak in kernel/module.c
so you can simply omit them here.

	Arnd
