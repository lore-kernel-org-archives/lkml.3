Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633AbaGHXoD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 19:44:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38065 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbaGHXn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 19:43:59 -0400
Date: Tue, 8 Jul 2014 16:48:24 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Anil Belur <askb23@gmail.com>
Cc: teobaluta@gmail.com, oleg.drokin@intel.com, dmitry.eremin@intel.com,
        bergwolf@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] staging: lustre: libcfs: nidstrings.c - use
 ARRAY_SIZE macro
Message-ID: <20140708234824.GA31003@kroah.com>
References: <1404298435-9729-1-git-send-email-askb23@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404298435-9729-1-git-send-email-askb23@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 04:23:55PM +0530, Anil Belur wrote:
> From: Anil Belur <askb23@gmail.com>
> 
> - this patch replaces sizeof(a)/sizeof(a[0]) with the ARRAY_SIZE macro
>   to get the number of nidstrings (and netstrfns)
> - v2: also for netstrfns
> 
> Signed-off-by: Anil Belur <askb23@gmail.com>

Someone sent this same patch just before you did, sorry :(

