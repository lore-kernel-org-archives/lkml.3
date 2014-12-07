Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311AbaLGN6u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 08:58:50 -0500
Received: from mail-qg0-f49.google.com ([209.85.192.49]:40207 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155AbaLGN6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 08:58:46 -0500
From: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: next-20141204 crashing on ext4_fill_super()
Date: Sun, 07 Dec 2014 11:58:40 -0200
Message-ID: <2207531.PyHK0LI72j@laptop>
User-Agent: KMail/4.13.3 (Linux/3.18.0-rc7-next-20141205-panda-00001-gf008c8b; KDE/4.13.3; x86_64; ; )
In-Reply-To: <20141206221621.GB27484@thunk.org>
References: <2144577.XOl86X9GoH@laptop> <20141206221621.GB27484@thunk.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, December 06, 2014 05:16:21 PM Theodore Ts'o wrote:
> Please revert fdfe07398761 and that should the crashes; this will be
> fixed in the next linux-next release.  My apologies for the inconvenience.
> 
>       	     	  	     	       	  	    - Ted
Hello, Ted.

Reverting that commit worked.  No need to apologize.

Thanks a lot for the quick reply.

-- 
Murilo
