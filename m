Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbbAWG23 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 01:28:29 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:51113 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbbAWG21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 01:28:27 -0500
Date: Fri, 23 Jan 2015 08:28:20 +0200
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: arnd@arndb.de, ebiederm@xmission.com, gnomes@lxorguk.ukuu.org.uk,
        teg@jklm.no, jkosina@suse.cz, luto@amacapital.net,
        linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        daniel@zonque.or, dh.herrmann@gmail.com, tixxdz@opendz.org,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Daniel Mack <daniel@zonque.org>
Subject: Re: [PATCH 01/13] kdbus: add documentation
Message-ID: <20150123062820.GB7949@Darwish.PC>
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org>
 <1421435777-25306-2-git-send-email-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421435777-25306-2-git-send-email-gregkh@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2015 at 11:16:05AM -0800, Greg Kroah-Hartman wrote:
> From: Daniel Mack <daniel@zonque.org>
> 
> kdbus is a system for low-latency, low-overhead, easy to use
> interprocess communication (IPC).
> 
> The interface to all functions in this driver is implemented via ioctls
> on files exposed through a filesystem called 'kdbusfs'. The default
> mount point of kdbusfs is /sys/fs/kdbus.

Pardon my ignorance, but we've always been told that adding
new ioctl()s to the kernel is a very big no-no.  But given
the seniority of the folks stewarding this kdbus effort,
there must be a good rationale ;-)

So, can the rationale behind introducing new ioctl()s be
further explained? It would be even better if it's included
in the documentation patch itself.

Thanks,
Darwish
