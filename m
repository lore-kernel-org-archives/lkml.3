Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672Ab3EJNBl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 09:01:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46155 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751785Ab3EJNBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 09:01:40 -0400
Date: Fri, 10 May 2013 14:58:26 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Lucas De Marchi <lucas.de.marchi@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/3] init/Kconfig: Add option to set modprobe command
Message-ID: <20130510125826.GA553@redhat.com>
References: <1368159316-31744-1-git-send-email-lucas.de.marchi@gmail.com> <1368159316-31744-3-git-send-email-lucas.de.marchi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368159316-31744-3-git-send-email-lucas.de.marchi@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10, Lucas De Marchi wrote:
>
> -char modprobe_path[KMOD_PATH_LEN] = "/sbin/modprobe -q --";
> +char modprobe_path[KMOD_PATH_LEN] = CONFIG_DEFAULT_MODULE_LOAD_BIN;

But even after 1/3 and 2/3 this can break free_modprobe_argv() ?
It assumes that argv[3] is module_name.

Oleg.

