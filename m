Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937AbaINRqY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 13:46:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43023 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498AbaINRqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 13:46:23 -0400
Date: Sun, 14 Sep 2014 10:46:22 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Stephan =?iso-8859-1?Q?M=FCller?= <fruktopus@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-api@vger.kernel.org
Subject: Re: [PATCH] Change userspace MKDEV, MAJOR, MINOR-macros from 8+8
 bit, to 12+20 bit layout
Message-ID: <20140914174622.GA10315@kroah.com>
References: <5415D1E0.3020905@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5415D1E0.3020905@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 14, 2014 at 07:35:28PM +0200, Stephan Müller wrote:
> Delete old userspace-only versions (8+8 bit). Instead expose the kernel-space
> definitions (12+20 bit).
> 
> Signed-off-by: Stephan Mueller <fruktopus@gmail.com>
> ---
> 
> Browsing some code I found that user-space and kernel-space macros for (un-)packing major/minor device numbers differ. The user-space ones using still the old 16 bit scheme. There was no explaining comment around and most libraries have their own macros anyway so it should not be a problematic UAPI change. So IMHO we could win some coherence in abandon this discrepancy.
> Please correct me if I am wrong.

You are wrong, we can't change this api, things will break :(

sorry,

greg k-h
