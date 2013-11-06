Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750839Ab3KFFCV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 00:02:21 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:51577 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701Ab3KFFCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 00:02:20 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <1383709721-22809-1-git-send-email-kmo@daterainc.com>
References: <1383709721-22809-1-git-send-email-kmo@daterainc.com>
Date: Tue, 5 Nov 2013 21:02:19 -0800
Message-ID: <CAOesGMjiPuqqP4oxd8vmvpbu5JZb=Nru59p5zX5KydAarSp2Rw@mail.gmail.com>
Subject: Re: [PATCH] block: Revert bio_clone() default behaviour
From: Olof Johansson <olof@lixom.net>
To: Kent Overstreet <kmo@daterainc.com>
Cc: Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>,
        Mike Snitzer <snitzer@redhat.com>, NeilBrown <neilb@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Nov 5, 2013 at 7:48 PM, Kent Overstreet <kmo@daterainc.com> wrote:

> Chris, Olaf, can you two in particular test this? I have tested the bounce
> buffer code (and bcache), but Jens told me today there was an md bug that I
> _still_ can't find any emails about so I'm not sure what to test for that.

(I'm guessing you mean me and not some German person here. :-)

What is this expected to apply on top of? It doesn't apply cleanly on
the 20131105 -next tree which is where I had been seeing the issues.


-Olof
