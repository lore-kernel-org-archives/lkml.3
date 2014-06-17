Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964904AbaFQUOf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 16:14:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55988 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932927AbaFQUOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 16:14:34 -0400
Date: Tue, 17 Jun 2014 13:18:31 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Nick Krause <xerofoify@gmail.com>
Cc: devel@driverdev.osuosl.org, ben@decadent.org.uk, lisa@xenapiadmin.com,
        Valentina Manea <valentina.manea.m@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] Check if skb_alloc returns Null in function
 fw_download_code
Message-ID: <20140617201831.GB6061@kroah.com>
References: <1403017516-4050-1-git-send-email-xerofoify@gmail.com>
 <20140617154600.GA14106@kroah.com>
 <CAPDOMVii1ZHTSsW5J4tjCgvqY1N-cJmULSFt1sB5fw2aabHnBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPDOMVii1ZHTSsW5J4tjCgvqY1N-cJmULSFt1sB5fw2aabHnBA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 12:04:59PM -0400, Nick Krause wrote:
> I created it using  git-format patch and check my condition is
> wrong should be !skb to check for Nulls .

That's not the real problem here.

The real issue is you can not apply your patch to any tree.  Please
remove all patches from your tree that you might have made and rebase
your change on top of a "clean" 3.16-rc1 kernel tree.

thanks,

greg k-h
