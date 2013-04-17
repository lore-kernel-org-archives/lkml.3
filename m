Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab3DQA7H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 20:59:07 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:43229 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830Ab3DQA7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 20:59:05 -0400
Date: Tue, 16 Apr 2013 17:58:55 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, Neela Syam Kolli <megaraidlinux@lsi.com>,
        devel@driverdev.osuosl.org, Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-scsi@vger.kernel.org, Jerry Chuang <jerry-chuang@realtek.com>,
        linux-wireless@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 10/28] proc: Add proc_mkdir_data() [RFC]
Message-ID: <20130417005855.GC11541@kroah.com>
References: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk>
 <20130416182630.27773.83021.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130416182630.27773.83021.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 07:26:30PM +0100, David Howells wrote:
> Add proc_mkdir_data() to allow procfs directories to be created that are
> annotated at the time of creation with private data rather than doing this
> post-creation.  This means no access is then required to the proc_dir_entry
> struct to set this.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Neela Syam Kolli <megaraidlinux@lsi.com>
> cc: Jerry Chuang <jerry-chuang@realtek.com>
> cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> cc: linux-scsi@vger.kernel.org
> cc: devel@driverdev.osuosl.org
> cc: linux-wireless@vger.kernel.org
> ---

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
