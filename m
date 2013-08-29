Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207Ab3H2Bfm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 21:35:42 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:61118 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755067Ab3H2Bfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 21:35:39 -0400
Message-ID: <521EA567.1070801@gmail.com>
Date: Thu, 29 Aug 2013 10:35:35 +0900
From: Akira Hayakawa <ruby.wktk@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: dm-devel@redhat.com
CC: gregkh@linuxfoundation.org, kernelnewbies@kernelnewbies.org,
        linux-kernel@vger.kernel.org
Subject: [RFC] dm-lc: plan to go to staging
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am happy to see that dm-lc is picked up by LWN.
http://lwn.net/Articles/562938/

Now I think I should consider the next step forward.


As Joe Thornber said before, what I have to do next are
1. Get some feedback from 3rd party users.
2. Reviewed by Mike Snitzer.
As in
http://www.redhat.com/archives/dm-devel/2013-July/msg00137.html

To achieve the first goal,
I am thinking of going to staging tree
for dm-lc to be widely available to people in community.

dm-lc is now managed in Github repo as a kernel module
however, getting available in the tree means a lot
to get 3rd party users.

Does this plan sound nice?

If so, what is the next step to go to staging?
I have a patch against 3.11-rc7 in linux-next locally.
Sending the patch to Greg is the next step?
And who and what should be included in CC?

For your information,
there is a precedent that DM target
gets in staging tree. That is enhanceio, also a caching target.

Any comments will be appreciated.

Thanks,
Akira
