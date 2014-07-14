Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497AbaGNHEZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 03:04:25 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:62624 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbaGNHEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 03:04:14 -0400
MIME-Version: 1.0
In-Reply-To: <20140713115022.GA6054@infradead.org>
References: <1404452632-10912-1-git-send-email-pramod.gurav.etc@gmail.com>
	<20140713115022.GA6054@infradead.org>
Date: Mon, 14 Jul 2014 12:34:12 +0530
Message-ID: <CAMf-jSmR1eU99VE+PKREufRZd=3cs7fSxyxosiidWj9CDy-65g@mail.gmail.com>
Subject: Re: [PATCH] fs/direct-io.c: Fix compilation warning for uninitialized variables
From: pramod gurav <pramod.gurav.etc@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Christoph for the review. :)

On Sun, Jul 13, 2014 at 5:20 PM, Christoph Hellwig <hch@infradead.org> wrote:
> Looks good to me,
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
>
> Al, can you pick this up?  It's the only warnings in many of my usual
> kernel builds at the moment.
>



-- 
Thanks and Regards
Pramod
