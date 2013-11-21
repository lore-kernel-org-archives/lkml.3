Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197Ab3KUS7E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 13:59:04 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:47664 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754014Ab3KUS7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 13:59:03 -0500
X-Sasl-enc: xYkz2Sz9zBSiUE07+yhSHA3iq/To/N8CNjvSQtBzdNf5 1385060341
Date: Thu, 21 Nov 2013 10:59:00 -0800
From: Greg KH <greg@kroah.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org
Subject: Re: [PATCH 1/6] kexec: Export vmcoreinfo note size properly
Message-ID: <20131121185900.GB17070@kroah.com>
References: <1384969851-7251-1-git-send-email-vgoyal@redhat.com>
 <1384969851-7251-2-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384969851-7251-2-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 12:50:46PM -0500, Vivek Goyal wrote:
> Right now we seem to be exporting the max data size contained inside
> vmcoreinfo note. But this does not include the size of meta data around
> vmcore info data. Like name of the note and starting and ending elf_note.
> 
> I think user space expects total size and that size is put in PT_NOTE
> elf header.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  kernel/ksysfs.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

This should go into 3.13, right?

Nice fix.

greg k-h
