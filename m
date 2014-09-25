Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563AbaIYGHR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 02:07:17 -0400
Received: from mail-oi0-f48.google.com ([209.85.218.48]:36636 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbaIYGHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 02:07:15 -0400
Date: Thu, 25 Sep 2014 01:07:09 -0500
From: Chuck Ebbert <cebbert.lkml@gmail.com>
To: Jason Vas Dias <jason.vas.dias@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: mount BTRFS filesystems created with 3.8+ under 2.6.32 kernels
 ?
Message-ID: <20140925010709.56113e17@as>
In-Reply-To: <CALyZvKyHQVeEZ+r3qRLXx15AXnj0-8hqfD4FNxHmQrMtygmpJg@mail.gmail.com>
References: <CALyZvKz4gyH64an3NWz2zY4b0NN34LwSME-oD8-Vw+e1SCF0Nw@mail.gmail.com>
	<CALyZvKyHQVeEZ+r3qRLXx15AXnj0-8hqfD4FNxHmQrMtygmpJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2014 19:07:39 +0100
Jason Vas Dias <jason.vas.dias@gmail.com> wrote:

> Of course the solution was to have created the filesystem in the first
> place with
> 'mkfs.btrfs -O ^extref' . Found this after some more googling ...
> Shouldn't this be the default ?

Even worse, your vendor might change the default, like Red Hat did in
RHEL 7. ext4 filesystems created by the installer, even very small ones,
get the 64bit feature enabled and can't be mounted in RHEL 6.5.
