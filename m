Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717AbaHJMYr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 08:24:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42902 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbaHJMYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 08:24:46 -0400
Date: Sun, 10 Aug 2014 05:24:11 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Junien Fridrick <linux.kernel@junien.fridrick.net>
Cc: Lai Siyao <lai.siyao@intel.com>, Oleg Drokin <oleg.drokin@intel.com>,
        "John L. Hammond" <john.hammond@intel.com>,
        Jinshan Xiong <jinshan.xiong@intel.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [next-20140808] [staging] [lustre] Fix coding style in
 llite/remote_perm.c
Message-ID: <20140810122411.GF28863@kroah.com>
References: <1407615768-6757-1-git-send-email-linux.kernel@junien.fridrick.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407615768-6757-1-git-send-email-linux.kernel@junien.fridrick.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 09, 2014 at 08:22:48PM +0000, Junien Fridrick wrote:
> Sorry for the noise, this is part of task 10 of the Eudyptula Challenge.

It's not noise at all, but it's not needed in the changelog comment, as
was pointed out.

Can you resend without this line, and actually say _what_ coding style
change you made?  And drop all of the [ ] in the subject, except for the
[PATCH] part, that's not needed, just use ':' instead, so it would look
like:
	Subject: [PATCH] staging: lustre: fix...

thanks,

greg k-h
