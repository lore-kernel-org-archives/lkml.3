Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756432Ab3AYKVZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 05:21:25 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:55710 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756348Ab3AYKVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 05:21:14 -0500
MIME-Version: 1.0
X-Originating-IP: [188.6.195.195]
In-Reply-To: <50F573CA.90402@parallels.com>
References: <20121116170123.3196.93431.stgit@maximpc.sw.ru>
	<50C89A78.4010309@parallels.com>
	<50F573CA.90402@parallels.com>
Date: Fri, 25 Jan 2013 11:21:13 +0100
Message-ID: <CAJfpegsp5_Mges1NAZbPSn-q+0O_EgJyroQsf-Vjy20O8DmfLA@mail.gmail.com>
Subject: Re: [PATCH v2 00/14] fuse: An attempt to implement a write-back cache policy
From: Miklos Szeredi <miklos@szeredi.hu>
To: "Maxim V. Patlasov" <mpatlasov@parallels.com>
Cc: Kirill Korotaev <dev@parallels.com>,
        "fuse-devel@lists.sourceforge.net" <fuse-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        James Bottomley <jbottomley@parallels.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Pavel Emelianov <xemul@parallels.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 4:20 PM, Maxim V. Patlasov
<mpatlasov@parallels.com> wrote:
> Heard nothing from you for two months. Any feedback would still be
> appreciated.

Sorry about the long silence.

I haven't done a detailed review yet.  It would be good if you could
resent the patchset against for-next branch of the fuse tree.

I see that you have some other patchsets pending.   Are they independent?

Thanks,
Miklos
