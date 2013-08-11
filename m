Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500Ab3HKIOM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 04:14:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46278 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288Ab3HKIOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 04:14:09 -0400
Date: Sun, 11 Aug 2013 01:15:33 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Thomas Fjellstrom <thomas@fjellstrom.ca>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ 044/102] ath: wil6210: Fix build error
Message-ID: <20130811081533.GA433@kroah.com>
References: <20130809015010.208118575@linuxfoundation.org>
 <20130809015020.242015405@linuxfoundation.org>
 <1415030.bySVpiWVc1@lx-vladimir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415030.bySVpiWVc1@lx-vladimir>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 11, 2013 at 11:09:24AM +0300, Vladimir Kondratiev wrote:
> On Thursday, August 08, 2013 06:57:20 PM Greg Kroah-Hartman wrote:
> > 3.10-stable review patch.  If anyone has any objections, please let me know.
> 
> This one is good for stable. I'd suggest to apply also commit
> c6c7788fe26fdc91e729f60742815ccdb505fd81 - wil6210: drop -Werror compiler flag
> it is not in Linus's tree yet, but in Linville's wireless-next

As it's not in Linus's tree yet, please resend this request when it hits
that tree, as there's nothing I can do at the moment with this, and I
know I will not remember it :)

thanks,

greg k-h
