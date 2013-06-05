Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148Ab3FEUOt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 16:14:49 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60352 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932086Ab3FEUOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 16:14:47 -0400
X-Sasl-enc: enrF6YftY0b/e7ClsfdPPT+q9ZbXac0QgX213qdb8/Cq 1370463285
Date: Wed, 5 Jun 2013 13:14:44 -0700
From: Greg KH <greg@kroah.com>
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Jonghwan Choi <jhbird.choi@samsung.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        "'Vahram Martirosyan'" <vahram.martirosyan@linuxtesting.org>
Subject: Re: [PATCH 3.9-stable]  jfs: Several bugs in jfs_freeze() and
 jfs_unfreeze()
Message-ID: <20130605201444.GA13713@kroah.com>
References: <000001ce60c9$622de130$2689a390$%choi@samsung.com>
 <51AF3CCE.1060908@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51AF3CCE.1060908@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 08:27:42AM -0500, Dave Kleikamp wrote:
> On 06/03/2013 09:15 PM, Jonghwan Choi wrote:
> > This patch looks like it should be in the 3.9-stable tree, should we apply
> > it?
> 
> I'm kind of on the fence on this one. I believe the failure here was
> triggered by induced errors to check the error paths. I'm not aware of a
> real-world crash due to the problem being fixed here. Of course, it's
> possible, but I don't think it's very likely.

Thanks for letting us know, I'll not apply it.

greg k-h
