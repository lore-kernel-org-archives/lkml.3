Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159AbaBXPMF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 10:12:05 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:61050 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbaBXPMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 10:12:03 -0500
MIME-Version: 1.0
X-Originating-IP: [93.172.86.48]
In-Reply-To: <1380825415-20481-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1380825415-20481-1-git-send-email-david.a.cohen@linux.intel.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 24 Feb 2014 17:11:41 +0200
Message-ID: <CAK=WgbYauDdtdWJ1SnGM5UD9-ECFZBGOWpru-geY+=xz=xgkCw@mail.gmail.com>
Subject: Re: [PATCH] rpmsg: reduce rpmsg_virtio verbosity
To: David Cohen <david.a.cohen@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jocelyn Falempe <jocelyn.falempe@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

Sorry for the late response.

On Thu, Oct 3, 2013 at 9:36 PM, David Cohen
<david.a.cohen@linux.intel.com> wrote:
> From: Jocelyn Falempe <jocelyn.falempe@intel.com>
>
> rpmsg_virtio TX/RX messages are very verbose, overflowing kernel printk
> buffer. This patch makes the guilty print_hex_dump()'s to act as
> dev_dbg() and do nothing in case neither DEBUG nor CONFIG_DYNAMIC_DEBUG
> are defined.
>
> Signed-off-by: Jocelyn Falempe <jocelyn.falempe@intel.com>
> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>

This sounds like a good thing to do, but I wonder if it should be
implemented in a more generic way, so other users of
print_hex_dump_debug can benefit from this as well?

Thanks,
Ohad.
