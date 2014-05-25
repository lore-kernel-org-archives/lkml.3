Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424AbaEYXSj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 19:18:39 -0400
Received: from mta-out1.inet.fi ([62.71.2.199]:44189 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078AbaEYXSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 19:18:38 -0400
Date: Mon, 26 May 2014 02:18:32 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: "Yann E. MORIN" <yann.morin.1998@free.fr>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kconfig: plug false-positive warning in get_prompt_str()
 seen with gcc-4.9
Message-ID: <20140525231832.GA1731@node.dhcp.inet.fi>
References: <20140525164751.28577.74072.stgit@zurg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140525164751.28577.74072.stgit@zurg>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 25, 2014 at 08:47:51PM +0400, Konstantin Khlebnikov wrote:
> scripts/kconfig/menu.c: In function ‘get_symbol_str’:
> scripts/kconfig/menu.c:590:18: warning: ‘jump’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>      jump->offset = strlen(r->s);
>                   ^

BTW, why do we need strlen() there? what's wrong with r->len?

-- 
 Kirill A. Shutemov
