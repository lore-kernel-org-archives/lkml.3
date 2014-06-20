Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932514AbaFTCz6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 22:55:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54127 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754626AbaFTCz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 22:55:57 -0400
Date: Thu, 19 Jun 2014 19:59:57 -0700
From: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Wolfram Sang'" <wsa@the-dreams.de>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 0/3] Remove devm_request_and_ioremap()
Message-ID: <20140620025957.GA27387@kroah.com>
References: <1403203741-5113-1-git-send-email-wsa@the-dreams.de>
 <000c01cf8c30$613759d0$23a60d70$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000c01cf8c30$613759d0$23a60d70$%han@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 11:36:03AM +0900, Jingoo Han wrote:
> On Friday, June 20, 2014 3:49 AM, Wolfram Sang wrote:
> > 
> > Pretty much a year ago, Tushar cleaned up a lot of deprecated uses of
> > devm_request_and_ioremap, yet some remains are still left. Remove the last two
> > users, and let the function rest in peace. I'd suggest that this series is
> > picked up as a whole to have that case finally closed. Greg? Are you interested
> > in picking it up?
> 
> (+cc Greg Kroah-Hartman)
> 
> I already sent the same patch as one single patch to Greg Kroah-Hartman. [1]
> Also, it was accepted by Greg Kroah-Hartman. [2] Thank you.
> 
> [1] https://lkml.org/lkml/2014/6/11/26
> [2] https://lkml.org/lkml/2014/6/11/649

Yeah, I'll go apply that right now while I'm remembering it :)

thanks,

greg k-h
