Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204Ab3AMUvD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 15:51:03 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56641 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755216Ab3AMUvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 15:51:01 -0500
Message-ID: <50F31E2C.3050104@suse.cz>
Date: Sun, 13 Jan 2013 21:50:52 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tiana Rakotovao Andriamahefa <rkmahefa@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts: kconfig: qconf.cc: fix a compiliation error
 when using make xconfig
References: <1358047720-10358-1-git-send-email-rkmahefa@gmail.com>
In-Reply-To: <1358047720-10358-1-git-send-email-rkmahefa@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.1.2013 04:28, Tiana Rakotovao Andriamahefa wrote:
> When using make xconfig, the following compilation error appears :
>    /usr/include/qt3/qvaluelist.h:427:13: error: ‘ptrdiff_t’ does not name a type
> Including stddef.h in scripts/kconfig/qconf.cc permits to avoid this error.

This is a bug in the Qt header. Is Qt3 still maintained?

Michal
