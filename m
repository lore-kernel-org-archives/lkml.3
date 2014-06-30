Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280AbaF3Pxg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 11:53:36 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:28501 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755245AbaF3Pxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 11:53:33 -0400
Date: Mon, 30 Jun 2014 11:53:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] debugfs: Fix corrupted loop in
 debugfs_remove_recursive
Message-ID: <20140630115331.5135b511@gandalf.local.home>
In-Reply-To: <20140610202302.GB20499@kroah.com>
References: <20140609140607.3e3aae39@gandalf.local.home>
	<20140610093357.7ef3792b@gandalf.local.home>
	<20140610202302.GB20499@kroah.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2014 13:23:02 -0700
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:


> Anyway, thanks for the patch, I'll queue it up after 3.16-rc1 is out.

Did this patch get dropped?

-- Steve

