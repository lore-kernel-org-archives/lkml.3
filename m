Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965986Ab3E2MYP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 08:24:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:40378 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965860Ab3E2MYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 08:24:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,763,1363158000"; 
   d="scan'208";a="321285927"
Message-ID: <1369830446.24286.20.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] UBI: Fastmap: Fix memory leak
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: Thomas Weber <thomas@tomweber.eu>, David Woodhouse <dwmw2@infradead.org>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        wang bo <wang.bo116@zte.com.cn>
Date: Wed, 29 May 2013 15:27:26 +0300
In-Reply-To: <51A3150C.7080009@nod.at>
References: <CAFLxGvw5gj-dfQeMKQVJpHPAXi4ZeNTaG3u3yXOAkshJRavXVA@mail.gmail.com>
	 <1369641744-13534-1-git-send-email-thomas@tomweber.eu>
	 <51A3150C.7080009@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-27 at 10:10 +0200, Richard Weinberger wrote:
> Hi!
> 
> Am 27.05.2013 10:02, schrieb Thomas Weber:
> > Signed-off-by: wang bo <wang.bo116@zte.com.cn>
> >
> > [fix whitespace errors]
> >
> > Tested with linux-v3.10-rc3 on Devkit8000.
> > Signed-off-by: Thomas Weber <thomas@tomweber.eu>
> >
> > The discussion about this patch can be found:
> > https://lkml.org/lkml/2013/5/2/118
> 
> Thanks a lot for fixing the whitespace issues!
> Am I allowed to add a Tested-by: Thomas Weber <thomas@tomweber.eu>?
> IOW did you test the patch? :D

Did you intend to re-send the patch with all the tags at proper places?

-- 
Best Regards,
Artem Bityutskiy

