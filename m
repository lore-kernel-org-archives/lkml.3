Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbaBEPFl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 10:05:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52965 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452AbaBEPFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 10:05:39 -0500
Message-ID: <52F2533F.2020302@suse.cz>
Date: Wed, 05 Feb 2014 16:05:35 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>, Kirill Tkhai <tkhai@yandex.ru>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Makefile, CONFIG_MODVERSIONS, ignore *.mod.c files
References: <1391612511-9276-1-git-send-email-prarit@redhat.com>
In-Reply-To: <1391612511-9276-1-git-send-email-prarit@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-02-05 16:01, Prarit Bhargava wrote:
> Add *.mod.c to the RCS_FIND_IGNORE in the top-level Makefile and to the ignore
> list in scripts/tags.sh.


This breaks make clean, which is supposed to remove the *.mod.c files.

Michal

