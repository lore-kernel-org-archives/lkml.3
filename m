Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935679AbaDJP6V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 11:58:21 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59690 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934689AbaDJP6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 11:58:19 -0400
X-Sasl-enc: YHfqlNb9a0hPFerF1Hvitq6wNW07W1CHzDCW36bliabH 1397145496
Date: Thu, 10 Apr 2014 09:00:49 -0700
From: Greg KH <greg@kroah.com>
To: Borislav Petkov <bp@alien8.de>
Cc: stable@vger.kernel.org, Matt Fleming <matt@console-pimps.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH for 3.14.y] x86/efi: Make efi virtual runtime map passing
 more robust
Message-ID: <20140410160049.GD10958@kroah.com>
References: <20140410130009.GJ29093@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140410130009.GJ29093@pd.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 03:00:09PM +0200, Borislav Petkov wrote:
> Hi Greg,
> 
> please take the patch into the stable 3.14.y queue. It fixes a number
> of EFI machines which makes a stable backport a good thing. Before you
> apply it though, cherry-pick 42a5477251f on which this patch depends.
> Then, you apply the backport I'm adding below.

Now applied, thanks.

greg k-h
