Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbaBEPIQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 10:08:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33867 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650AbaBEPIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 10:08:14 -0500
Message-ID: <52F253D6.2060100@redhat.com>
Date: Wed, 05 Feb 2014 10:08:06 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Kirill Tkhai <tkhai@yandex.ru>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Makefile, CONFIG_MODVERSIONS, ignore *.mod.c files
References: <1391612511-9276-1-git-send-email-prarit@redhat.com> <52F2533F.2020302@suse.cz>
In-Reply-To: <52F2533F.2020302@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/05/2014 10:05 AM, Michal Marek wrote:
> On 2014-02-05 16:01, Prarit Bhargava wrote:
>> Add *.mod.c to the RCS_FIND_IGNORE in the top-level Makefile and to the ignore
>> list in scripts/tags.sh.
> 
> 
> This breaks make clean, which is supposed to remove the *.mod.c files.
> 

Michal,

Oops. :(.  So just the scripts/tags.sh needs to modified.  I'll resubmit just
that patch unless you have a better suggestion.

P.

> Michal
> 
