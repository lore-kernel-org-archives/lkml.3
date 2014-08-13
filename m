Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751018AbaHMGtd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 02:49:33 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:39284 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbaHMGtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 02:49:31 -0400
Message-ID: <53EB0A79.1020301@infradead.org>
Date: Tue, 12 Aug 2014 23:49:29 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Fabio Estevam <festevam@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Masanari Iida <standby24x7@gmail.com>, Jim Davis <jim.epost@gmail.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, David Airlie <airlied@linux.ie>
Subject: Re: [PATCH] Documentation: DocBook: Rename drm_stub.c to drm_drv.c
 cause 'make xmldocs' failed
References: <1407525394-29821-1-git-send-email-standby24x7@gmail.com>	<53EA4F34.4050402@infradead.org> <CAOMZO5B_zXvMybFhr4mU2wvx4Boh-P3Tn5GLopUJU8A24mjdBA@mail.gmail.com>
In-Reply-To: <CAOMZO5B_zXvMybFhr4mU2wvx4Boh-P3Tn5GLopUJU8A24mjdBA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/14 18:17, Fabio Estevam wrote:
> On Tue, Aug 12, 2014 at 2:30 PM, Randy Dunlap <rdunlap@infradead.org> wrote:
>> This patch fixed 'make xmldocs' failed on linus's tree and
>> linux-next as of 8th/Aug,2014.
>>
>> When drm merge for 3.17-rc1 happen,  a file was renamed from
>> drm_stub.c to drm_drv.c.
>> But Documentation/DocBook/drm.tmpl still have an old file name.
>>
>> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> 
> Isn't the From field missing to indicate Masanari's authorship of this patch?

Hm, yes, I'm afraid that it is.  Sorry about that.

If Linus doesn't merge it, I'll add it to my patch queue or David Airlie
can do that as well.

Thanks.
-- 
~Randy
