Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbaJWH2N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 03:28:13 -0400
Received: from mail2.tiolive.com ([94.23.229.207]:58648 "EHLO
	mail2.tiolive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbaJWH2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 03:28:12 -0400
Date: Thu, 23 Oct 2014 11:28:10 +0400
From: Kirill Smelkov <kirr@nexedi.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Ken Chen <kenchen@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH,RESEND] hugetlbfs: document that sticky mounts are allowed
Message-ID: <20141023072810.GA15697@teco.navytux.spb.ru>
References: <1409836833-4320-1-git-send-email-kirr@nexedi.com>
 <CABQzsv_9K0WrddMW60DkUbsv2B5BwLNFCES2TNvfVNaG-ym6YA@mail.gmail.com>
 <20141022155446.GA20240@teco.navytux.spb.ru>
 <20141022142826.109c27cc@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141022142826.109c27cc@lwn.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 02:28:26PM -0400, Jonathan Corbet wrote:
> On Wed, 22 Oct 2014 19:54:46 +0400
> Kirill Smelkov <kirr@nexedi.com> wrote:
> 
> > Please apply the below patch documenting that hugetlbfs can be sticky-mounted.
> 
> It documents it in a rather obscure way...but, then, to be clear, that
> document needs a lot of help in general.

I agree the documentation is a bit obscure and it was not a proper fix,
but "let's at least restore consistency between .txt & .c"

> Applied.  Redundant Cc tag removed.

Thanks,
Kirill
