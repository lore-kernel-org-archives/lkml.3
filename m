Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751362AbaLCBbL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 20:31:11 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:42021 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750831AbaLCBbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 20:31:07 -0500
X-Sasl-enc: FNkpb/UeLYBMzHE3Zm7K+VU+gRmS+D2t8z45Gaptwynj 1417570266
Date: Tue, 2 Dec 2014 17:31:05 -0800
From: Greg KH <greg@kroah.com>
To: Paul H <paul@mybboard.net>
Cc: Paul H <paul@mybb.com>, Belisko Marek <marek.belisko@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: ft1000: fix spaces around comparisons in
 ft1000_debug.c
Message-ID: <20141203013105.GA21642@kroah.com>
References: <1417533075-687-1-git-send-email-paul@mybb.com>
 <20141203004852.GA15236@kroah.com>
 <CAO7UptcspiZCNi8smcmhOWM9Rdn+QYHPJYmZb90A-_3sJ4wYqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO7UptcspiZCNi8smcmhOWM9Rdn+QYHPJYmZb90A-_3sJ4wYqQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 07:10:41PM -0600, Paul H wrote:
> A tutorial I read suggested using a different branch for applying the
> patches; I named it "fix-spaces".  It would appear it is mistaken
> then?

You have to make your patch against the linux-next tree, not Linus's
tree, so as to not duplicate other people's work that has already been
accepted.

You can name your branch whatever you want to, that doesn't matter :)

greg k-h
