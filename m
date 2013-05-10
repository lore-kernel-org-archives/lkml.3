Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063Ab3EJNP6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 09:15:58 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:52953 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187Ab3EJNP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 09:15:57 -0400
MIME-Version: 1.0
In-Reply-To: <20130510125826.GA553@redhat.com>
References: <1368159316-31744-1-git-send-email-lucas.de.marchi@gmail.com>
 <1368159316-31744-3-git-send-email-lucas.de.marchi@gmail.com> <20130510125826.GA553@redhat.com>
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Fri, 10 May 2013 10:15:33 -0300
Message-ID: <CAKi4VALE8tFUTZ1qYwm0Eth1zFMU8xA6XC5RTnF1KCKYQp-0NQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] init/Kconfig: Add option to set modprobe command
To: Oleg Nesterov <oleg@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 9:58 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> On 05/10, Lucas De Marchi wrote:
> >
> > -char modprobe_path[KMOD_PATH_LEN] = "/sbin/modprobe -q --";
> > +char modprobe_path[KMOD_PATH_LEN] = CONFIG_DEFAULT_MODULE_LOAD_BIN;
>
> But even after 1/3 and 2/3 this can break free_modprobe_argv() ?
> It assumes that argv[3] is module_name.

Oh, right. Forgot about that. And this patch set should have been sent
as RFC, since I'm interested in feedback about the idea. What do you
think?



thanks

Lucas De Marchi
