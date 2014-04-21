Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862AbaDUSjt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 14:39:49 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:49220 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbaDUSjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 14:39:46 -0400
Message-ID: <535565EF.5090300@gmail.com>
Date: Mon, 21 Apr 2014 20:39:43 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: mtk.manpages@gmail.com, Rich Felker <dalias@libc.org>,
        Jeff Layton <jlayton@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
        Ganesha NFS List <nfs-ganesha-devel@lists.sourceforge.net>,
        "Carlos O'Donell" <carlos@redhat.com>,
        libc-alpha <libc-alpha@sourceware.org>,
        "Stefan (metze) Metzmacher" <metze@samba.org>
Subject: Re: [PATCH] locks: rename file-private locks to file-description
 locks
References: <1398087935-14001-1-git-send-email-jlayton@redhat.com> <20140421140246.GB26358@brightrain.aerifal.cx> <535529FA.8070709@gmail.com> <20140421161004.GC26358@brightrain.aerifal.cx> <5355644C.7000801@gmail.com> <20140421183439.GA17879@infradead.org>
In-Reply-To: <20140421183439.GA17879@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2014 08:34 PM, Christoph Hellwig wrote:
> On Mon, Apr 21, 2014 at 08:32:44PM +0200, Michael Kerrisk (man-pages) wrote:
>> So, can you *please* answer this question: what do you call (i.e., 
>> what  everyday technical language term do use for) the thing
>> that sits between a file descriptor and an i-node? 
> 
> An open file.

Not an unambiguous, widely understood term.


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
