Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092Ab3FFRmL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 13:42:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45213 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207Ab3FFRmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 13:42:09 -0400
Message-ID: <51B0C9E5.7030105@suse.cz>
Date: Thu, 06 Jun 2013 19:41:57 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Kyle McMartin <kyle@redhat.com>
Cc: linux-kbuild@vger.kernel.org, rob@landley.net,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] Kbuild: pass headers to headers_install.sh on stdin
References: <20130606170557.GQ14762@redacted.bos.redhat.com>
In-Reply-To: <20130606170557.GQ14762@redacted.bos.redhat.com>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 6.6.2013 19:05, Kyle McMartin napsal(a):
> While using make V=1 to test some things, I noticed on our builders that
> headers_install was failing because the argument list to /bin/sh was too
> long. Working around it is slightly kludgy...

This is already fixed with


commit c0ff68f1611d6855a06d672989ad5cfea160a4eb
Author: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Date:   Mon Apr 29 14:15:51 2013 +0200

    kbuild: fix make headers_install when path is too long


in linux-next.

Michal
