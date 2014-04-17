Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161359AbaDQNVr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 09:21:47 -0400
Received: from verein.lst.de ([213.95.11.211]:53931 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754845AbaDQNVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 09:21:46 -0400
Date: Thu, 17 Apr 2014 15:21:42 +0200
From: Torsten Duwe <duwe@lst.de>
To: Corey Minyard <minyard@acm.org>
Cc: Jiri Slaby <jslaby@suse.cz>, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org, Tomas Cech <tcech@suse.cz>,
        openipmi-developer@lists.sourceforge.net,
        Rocky Craig <rocky.craig@hp.com>
Subject: Re: [PATCH 1/1] Char: ipmi_bt_sm, fix infinite loop
Message-ID: <20140417132142.GA7976@lst.de>
References: <1393323294-11423-1-git-send-email-jslaby@suse.cz> <530D1021.1050402@acm.org> <533023F5.40909@suse.cz> <533080AB.9080702@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <533080AB.9080702@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2014 at 01:59:55PM -0500, Corey Minyard wrote:
> On 03/24/2014 07:24 AM, Jiri Slaby wrote:
> > On 02/25/2014 10:50 PM, Corey Minyard wrote:
> >> Looks right to me.  Rocky, copying you in case there's an issue with this.
> > Hi,
> >
> > any updates here, I don't see it in the -next tree yet?
> >
> > Thanks.
> 
> I normally don't submit to the -next tree because there is little to
> integrate with in the IPMI driver.  Maybe it would be a good idea to
> start, though.  If you want to, I can.

Yes, please! :)
And you may want to send bugfixes towards -stable.

Thanks,

	Torsten

