Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309AbaIOH10 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 03:27:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46880 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902AbaIOH1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 03:27:25 -0400
Date: Mon, 15 Sep 2014 00:27:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rob Jones <rob.jones@codethink.co.uk>
Cc: linux-kernel@vger.kernel.org, linux-kernel@codethink.co.uk
Subject: Re: [PATCH 0/2] fs: proc: use seq_open_private()
Message-Id: <20140915002721.347ad066.akpm@linux-foundation.org>
In-Reply-To: <54169389.6060608@codethink.co.uk>
References: <1410530978-29627-1-git-send-email-rob.jones@codethink.co.uk>
	<20140912145019.9e1665011c2d2e9bcb55f0c1@linux-foundation.org>
	<54169389.6060608@codethink.co.uk>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Sep 2014 08:21:45 +0100 Rob Jones <rob.jones@codethink.co.uk> wrote:

> On 12/09/14 22:50, Andrew Morton wrote:
> > On Fri, 12 Sep 2014 15:09:36 +0100 Rob Jones <rob.jones@codethink.co.uk> wrote:
> >
> >>    fs: proc: use __seq_open_private()
> >>    fs: proc: use __seq_open_private()
> >
> > See the problem?  We have two different patches, both named the same.
> 
> Always another gotcha! :-)
> 
> Seriously, does it say anywhere that patch names have to be unique? It
> makes perfect sense when it's pointed out but it never occurred to me.

Not explicitly as far as I know.  Documentation/SubmittingPatches
implies it.  Search for "unique".

