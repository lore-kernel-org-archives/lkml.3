Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098AbaESO26 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 10:28:58 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:37954 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbaESO25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 10:28:57 -0400
MIME-Version: 1.0
In-Reply-To: <20140519141309.GB21570@infradead.org>
References: <20140519141309.GB21570@infradead.org>
From: Jianyu Zhan <nasa4836@gmail.com>
Date: Mon, 19 May 2014 22:28:16 +0800
Message-ID: <CAHz2CGUXwQ33VwSYQFkBXMUFR=nH_JDf0Chzaj5PUNDMj3Au3A@mail.gmail.com>
Subject: Re: time to move fs/bio.c to block/ ?
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 10:13 PM, Christoph Hellwig <hch@infradead.org> wrote:
> I recently saw patches to fs/bio.c that were sent to Al instead of Jens.
> I think having bio.c in fs/ is rather confusing, so maybe it's time to
> include the simple git-mv for it in the your for-next tree?

Hi, Christoph, Jens,

BTW, just out of curiosity,  the VFS infrastructure code is just scatterd
around the fs directory, which is quite suprised to a new comer that why
there is "no" vfs stuff in fs directory.  Does it make sense to also collect
them into a dedicated sub-dir, maybe vfs.  IMHO, this could make code
skeleton more clear and could avoid such mis-sending patches in a long
term maintainability view.

Thanks,
Jianyu Zhan
