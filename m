Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315AbaCJTjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 15:39:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40531 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679AbaCJTjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 15:39:14 -0400
Date: Mon, 10 Mar 2014 12:39:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, davej <davej@redhat.com>
Subject: Re: [PATCH v2] affs: mount option to avoid name truncates
Message-Id: <20140310123912.013ca2583a13c0270d866213@linux-foundation.org>
In-Reply-To: <20140309195210.b48f05296677f2d5c6e46992@skynet.be>
References: <20140309195210.b48f05296677f2d5c6e46992@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Mar 2014 19:52:10 +0100 Fabian Frederick <fabf@skynet.be> wrote:

> Filename truncate process is defined in affs.h
> 
> This patch adds 'nofilenametruncate' mount option and
> removes AFFS_MAX_PREALLOC which is never used.
> 

The changelog provides not a hint about why we should add this.  What
is it for?  What value does it have to users?

Also, the new mount option should be documented in
Documentation/filesystems/affs.txt.

Please fix these things then resend?

