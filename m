Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880Ab3FYMAv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 08:00:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45704 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab3FYMAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 08:00:49 -0400
MIME-Version: 1.0
In-Reply-To: <20130625183355.464b44df82ffc033aab31a4d@canb.auug.org.au>
References: <20130625183355.464b44df82ffc033aab31a4d@canb.auug.org.au>
Date: Tue, 25 Jun 2013 20:00:47 +0800
Message-ID: <CACVXFVNUzNxwjFnDGSEEKAn81Guy1bF2_GncYe1+-WKOXtrXdQ@mail.gmail.com>
Subject: Re: linux-next: build warning after merge of the driver-core tree
From: Ming Lei <ming.lei@canonical.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 4:33 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Greg,
>
> After merging the driver-core tree, today's linux-next build (powerpc
> allnoconfig) produced this warning:
>
> drivers/base/firmware_class.c:221:29: warning: 'fw_lookup_buf' defined but not used [-Wunused-function]
>
> Introduced by commit 90f8908127b5 ("firmware loader: fix compile warning
> with PM_SLEEP set").

OK, I will submit a patch to kill the warning later, thanks again for
your report.


Thanks,
--
Ming Lei
