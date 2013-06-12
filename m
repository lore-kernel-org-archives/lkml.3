Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113Ab3FLRwR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 13:52:17 -0400
Received: from www.sr71.net ([198.145.64.142]:53644 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932070Ab3FLRwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 13:52:15 -0400
Message-ID: <51B8B54D.2040200@sr71.net>
Date: Wed, 12 Jun 2013 10:52:13 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Dave Hansen <dave.hansen@intel.com>, linux-ext4@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Jan kara <jack@suse.cz>, gnehzuil.liu@gmail.com
Subject: Re: ext4 extent status tree LRU locking
References: <51B7B128.60909@intel.com> <20130612071735.GB29898@gmail.com> <51B88F1A.5000909@intel.com> <20130612160320.GA29156@gmail.com>
In-Reply-To: <20130612160320.GA29156@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FWIW, I'm also seeing this contention to a much smaller extent on much
more "normal" hardware.  I've got a 6-core (as opposed to 80) desktop
machine where I'm doing the same test on a real disk (instead of a
loopback-mounted ramfs file).

I'm seeing _about_ 10% CPU time being used on just spinning on the same
ext4 LRU lock.
