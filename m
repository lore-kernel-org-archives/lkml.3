Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757839AbaD2QX3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 12:23:29 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:2945 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756465AbaD2QX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 12:23:28 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmISAHjRX1NbsnvL/2dsb2JhbABZgwaCQKldAQEBBAGZbQEFAgKBIxd0giUBAQQBOhwjBQsIAw4KLjkeBhOIOQwByRwXhVWIegeEOQEDmQ8BkmKDMzs
Date: Tue, 29 Apr 2014 18:25:30 +0200
From: Fabian Frederick <fabf@skynet.be>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, hch <hch@infradead.org>,
        Viro <viro@zeniv.linux.org.uk>, tytso <tytso@mit.edu>,
        akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH V3 1/2] FS: Add generic data flush to fsync
Message-Id: <20140429182530.177de75b86f4a074c2f536bf@skynet.be>
In-Reply-To: <20140429161907.GA29634@quack.suse.cz>
References: <20140428231239.dbae4da4297c0b9230d9db4d@skynet.be>
	<20140429161907.GA29634@quack.suse.cz>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 29 Apr 2014 18:19:07 +0200
Jan Kara <jack@suse.cz> wrote:

> On Mon 28-04-14 23:12:39, Fabian Frederick wrote:
> > This patch issues a flush in generic_file_fsync.
> > (Modern filesystems already do it)
> > 
> > -Behaviour can be reversed using /sys/devices/.../cache_type
> > -Filesystems can also call __generic_file_fsync with bool flush false
>   The patch looks good. You can add:
> Reviewed-by: Jan Kara <jack@suse.cz>
> 
> 								Honza

Just noticed I forgot to remove "with bool flush false" in patch description above
(-Filesystems can also call __generic_file_fsync "with bool flush false")
Tell me if I need to send the patch again.

Fabian


