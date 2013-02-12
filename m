Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933189Ab3BLNNb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 08:13:31 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:50529 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933048Ab3BLNNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 08:13:30 -0500
MIME-Version: 1.0
X-Originating-IP: [188.6.195.195]
In-Reply-To: <20130212104608.GA24042@amd.pavel.ucw.cz>
References: <1360113112.17267.1.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
	<2964781.rPUOipNRNb@vostro.rjw.lan>
	<CAJfpegtNUr+AJXZcKmLEGBYqu20DVFwzg-OvOk_nS3fBS3wd=Q@mail.gmail.com>
	<1660768.prnx6s70rD@vostro.rjw.lan>
	<CAJfpegt2B3n-QNK_W7O2H0JVfS=4jcUOzV_+w8ELPq19RJPewQ@mail.gmail.com>
	<20130212104608.GA24042@amd.pavel.ucw.cz>
Date: Tue, 12 Feb 2013 14:13:27 +0100
Message-ID: <CAJfpegvdVfEFTU5haMMi94PD1iZ1XyCRjg0O9vDjDg1yyaM-yA@mail.gmail.com>
Subject: Re: Getting rid of freezer for suspend [was Re: [fuse-devel] [PATCH]
 fuse: make fuse daemon frozen along with kernel threads]
From: Miklos Szeredi <miklos@szeredi.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Goswin von Brederlow <goswin-v-b@web.de>, Li Fei <fei.li@intel.com>,
        len.brown@intel.com, mingo@redhat.com, peterz@infradead.org,
        biao.wang@intel.com, linux-pm@vger.kernel.org,
        fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        chuansheng.liu@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 11:46 AM, Pavel Machek <pavel@ucw.cz> wrote:

> (After all, with FUSE, filesystem clients are just doing IPC. In ideal
> world, that would be freezeable and killable with -9).

Exactly.

Attaching a patch

>
>                                                                         Pavel
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
