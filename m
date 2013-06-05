Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133Ab3FEURN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 16:17:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35603 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932067Ab3FEURL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 16:17:11 -0400
Date: Wed, 5 Jun 2013 13:17:10 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
Cc: Jonghwan Choi <jhbird.choi@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Adamson, Andy" <William.Adamson@netapp.com>
Subject: Re: [PATCH 3.9-stable] NFSv4.1 Fix a pNFS session draining deadlock
Message-ID: <20130605201710.GC13713@kroah.com>
References: <000001ce5a70$7b9bd410$72d37c30$%choi@samsung.com>
 <1369617780.15984.9.camel@leira.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369617780.15984.9.camel@leira.trondhjem.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 27, 2013 at 01:23:05AM +0000, Myklebust, Trond wrote:
> On Mon, 2013-05-27 at 09:23 +0900, Jonghwan Choi wrote:
> > This patch looks like it should be in the 3.9-stable tree, should we apply
> > it?
> 
> It's a condition which appears to be extremely rare: so far, we've only
> seen it during extreme stress testing at NetApp. For that reason, and
> because it is NFSv4.1 only, I'm inclined to wait until we see real-world
> cases before making it a stable patch.

Thanks for letting us know, I'll not apply it unless you say we should
later on.

greg k-h
