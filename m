Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021AbaDHUVc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 16:21:32 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:61922 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756036AbaDHUVa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 16:21:30 -0400
MIME-Version: 1.0
In-Reply-To: <1396988442.14321.0.camel@joe-AO722>
References: <1396988297-29240-1-git-send-email-eu@opreamatei.ro>
	<1396988442.14321.0.camel@joe-AO722>
Date: Tue, 8 Apr 2014 23:21:30 +0300
Message-ID: <CABeAxac1mPiF9_=eiMn4_KFUNkgD9UDop_anwevtBm7nRE0O4Q@mail.gmail.com>
Subject: Re: [PATCH] scsi: lpfc: lpfc_init: use kcalloc for allocating memory
From: Matei Oprea <eu@opreamatei.ro>
To: Joe Perches <joe@perches.com>
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        ROSEdu Kernel Community <firefly@lists.rosedu.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok. Sorry.
ᐧ

On Tue, Apr 8, 2014 at 11:20 PM, Joe Perches <joe@perches.com> wrote:
> On Tue, 2014-04-08 at 23:18 +0300, Matei Oprea wrote:
>> It's easier to use kcalloc for allocating arrays. While at it
>> also remove useless casting value.
>
> Don't send a patch against your bad patch.
> Send a new patch with just the appropriate
> changes.
>
>



-- 
Oprea Matei
