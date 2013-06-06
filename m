Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201Ab3FFH7G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 03:59:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59539 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911Ab3FFH7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 03:59:03 -0400
MIME-Version: 1.0
In-Reply-To: <20130606173243.ba35169ddc8bcc32a81a9669@canb.auug.org.au>
References: <20130606173243.ba35169ddc8bcc32a81a9669@canb.auug.org.au>
Date: Thu, 6 Jun 2013 15:59:01 +0800
Message-ID: <CACVXFVN7qTcj_rLAj+2RrVaLtOf3jNdt3FoOPS1QaAZADefs3A@mail.gmail.com>
Subject: Re: linux-next: build warning after merge of the final tree
 (driver-core tree related)
From: Ming Lei <ming.lei@canonical.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 6, 2013 at 3:32 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> After merging the final tree, today's linux-next build (sparc32 defconfig)
> produced this warning:
>
> drivers/base/firmware_class.c:921:13: warning: 'kill_requests_without_uevent' defined but not used [-Wunused-function]

Hmm, miss test with !CONFIG_PM_SLEEP.

I will post a patch to fix the warning, sorry for introducing these things.

Thanks,
--
Ming Lei
