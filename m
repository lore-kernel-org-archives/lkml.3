Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827Ab3LLAZj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 19:25:39 -0500
Received: from mail-vc0-f175.google.com ([209.85.220.175]:44593 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab3LLAZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 19:25:36 -0500
MIME-Version: 1.0
In-Reply-To: <1386269247-32401-1-git-send-email-boris.ostrovsky@oracle.com>
References: <1386269247-32401-1-git-send-email-boris.ostrovsky@oracle.com>
Date: Wed, 11 Dec 2013 16:25:36 -0800
Message-ID: <CA+8MBbKRfV6K4GhhGrNQt4okQZgkV=gR7xw=NH6-VLMoX_--GA@mail.gmail.com>
Subject: Re: [PATCH] ia64/xen: Remove Xen support for ia64
From: Tony Luck <tony.luck@gmail.com>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: "Yu, Fenghua" <fenghua.yu@intel.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        xen-devel@lists.xenproject.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 5, 2013 at 10:47 AM, Boris Ostrovsky
<boris.ostrovsky@oracle.com> wrote:
> ia64 has not been supported by Xen since 4.2 so it's time to drop
> Xen/ia64 from Linux as well.
>
> Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> ---
>
> This is only compile-tested.

Boot tested on a couple of different ia64 machines with no surprises.

Will apply - thanks.

-Tony
