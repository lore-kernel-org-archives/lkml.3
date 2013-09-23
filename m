Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227Ab3IWFwd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 01:52:33 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:49009 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335Ab3IWFwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 01:52:32 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20130923132122.584a5166d14d0ec6d6f1a3a4@canb.auug.org.au>
References: <20130923132122.584a5166d14d0ec6d6f1a3a4@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: linux-next: manual merge of the staging tree with the staging.current tree
From: Jonathan Cameron <jic23@kernel.org>
Date: Mon, 23 Sep 2013 06:52:26 +0100
To: Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yann Droneaud <ydroneaud@opteya.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Message-ID: <b269f4dd-8e11-4803-a4cb-72c392dfae55@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Stephen.

Sorry Greg, I meant to mention these two would occur but clean forgot when sending that pull request.

Both are are correctly merged by Stephen.

Jonathan



Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>Hi Greg,
>
>Today's linux-next merge of the staging tree got a conflict in
>drivers/iio/industrialio-event.c between commit cadc2125e140 ("iio:
>fix:
>Keep a reference to the IIO device for open file descriptors") from the
>staging.current tree and commit a646fbf0fd11 ("iio: use
>anon_inode_getfd
>() with O_CLOEXEC flag") from the staging tree.
>
>I fixed it up (see below) and can carry the fix as necessary (no action
>is required).

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
