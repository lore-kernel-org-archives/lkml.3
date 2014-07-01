Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758147AbaGAPb0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 11:31:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:9088 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755081AbaGAPbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 11:31:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="358687998"
Message-ID: <1404228681.6841.130.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] UBIFS: fix some comments
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Seunghun Lee <waydi1@gmail.com>, adrian.hunter@intel.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Date: Tue, 01 Jul 2014 18:31:21 +0300
In-Reply-To: <53B2D378.7010006@infradead.org>
References: <1404225925-3347-1-git-send-email-waydi1@gmail.com>
	 <53B2D378.7010006@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-01 at 08:27 -0700, Randy Dunlap wrote:
> > - * This function returns %0 on success and a negative error code on failure.
> > + * This function returns the scaned information on success and a negative error
> 
>                                 scanned

I'll correct this, thanks!

-- 
Best Regards,
Artem Bityutskiy

