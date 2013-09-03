Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807Ab3ICWCe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 18:02:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60650 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684Ab3ICWCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 18:02:33 -0400
Date: Tue, 3 Sep 2013 15:02:32 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        john453@faraday-tech.com
Subject: Re: usb: host: Faraday fotg210-hcd driver
Message-ID: <20130903220232.GA22070@kroah.com>
References: <20130903185912.A59316601F4@gitolite.kernel.org>
 <20130903211544.GB2247@redhat.com>
 <20130903212355.GA12978@kroah.com>
 <20130903213205.GA7433@redhat.com>
 <20130903214009.GA16463@kroah.com>
 <20130903214626.GA10542@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130903214626.GA10542@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 03, 2013 at 05:46:26PM -0400, Dave Jones wrote:
> On Tue, Sep 03, 2013 at 02:40:09PM -0700, Greg KH wrote:
>  > On Tue, Sep 03, 2013 at 05:32:05PM -0400, Dave Jones wrote:
>  
>  > > PS: What happened with this driver ?
>  > > 
>  > > This patch landed twice in your tree, once in 1dd3d123239179fad5de5dc00a6e0014a1918fde from Yuan-Hsin Chen <yhchen@faraday-tech.com>
>  > > and then in 7d50195f6c5005d6ae7a789d9a7f0a94d104ee96 from Feng-Hsin Chiang <john453@faraday-tech.com>
>  > > 
>  > > Given the former address seems to be broken, perhaps all those mentions of it
>  > > in the faraday sources need updating ?
>  > 
>  > I thought they had all been fixed up.  The first version was dropped
>  > because the maintainer no longer worked for the company (as you found
>  > out), so I needed a new developer to step up and support it.
> 
> He's still mentioned in a bunch of MODULE_AUTHOR's.
> While it seems sort of rude to delete mention of someones work, having a dead email
> address seems bad form too. Perhaps the patch below ?

That looks good, I'll queue it up, thanks.

greg k-h
