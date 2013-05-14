Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758003Ab3ENSlD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 14:41:03 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:65157 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656Ab3ENSlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 14:41:01 -0400
Date: Tue, 14 May 2013 14:41:12 -0400
From: Greg KH <gregkh@linuxfoundation.org>
To: Igor Mammedov <imammedo@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        chuck.anderson@oracle.com
Subject: Re: [PATCH 0/2 v2] cpu: fix leaks and udev race in register_cpu()
Message-ID: <20130514184112.GA726@kroah.com>
References: <1368542767-2126-1-git-send-email-imammedo@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368542767-2126-1-git-send-email-imammedo@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 04:46:05PM +0200, Igor Mammedov wrote:
> 1. move "crash_notes" and "crash_notes_size" to static attributes to
> guarantee that it's destroyed with CPU on unregister.
> 
> 2. fixes race between hotplugged CPU and onlining it via udev,
> described at https://lkml.org/lkml/2012/4/30/193
> 
> Igor Mammedov (2):
>   cpu: fix "crash_notes" and "crash_notes_size" leaks in register_cpu()
>   cpu: make sure that cpu/online file created before KOBJ_ADD is
>     emitted
> 
>  drivers/base/cpu.c |   59 ++++++++++++++++++++++++++++++++++-----------------
>  1 files changed, 39 insertions(+), 20 deletions(-)

Nice, give me a few days to catch up with my patch queue, and I'll apply
this.

greg k-h
