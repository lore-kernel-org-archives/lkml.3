Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757127Ab3DXB51 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 21:57:27 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:57226 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755473Ab3DXB5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 21:57:25 -0400
Date: Tue, 23 Apr 2013 18:57:22 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: ZhenHua <zhen-hual@hp.com>
Cc: stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, tom.vaden@hp.com
Subject: Re: [PATCH 1/1] driver,usb: Fix a warning in uhci-hcd driver
Message-ID: <20130424015722.GA1269@kroah.com>
References: <1366701301-16603-1-git-send-email-zhen-hual@hp.com>
 <20130423140734.GA30877@kroah.com>
 <51771F66.3080801@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51771F66.3080801@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 24, 2013 at 07:55:18AM +0800, ZhenHua wrote:
> On 04/23/2013 10:07 PM, Greg KH wrote:
> >On Tue, Apr 23, 2013 at 03:15:01PM +0800, Li, Zhen-Hua wrote:
> >>From: "Li, Zhen-Hua" <zhen-hual@hp.com>
> >>
> >>This patch is trying to fix bug QXCR1001261767.
> Sorry for the bug number. Please ignore this line.

I don't want to ignore it, I want it to point to something that I, and
others, can reference in the future.  Is there a url you can use for it?

thanks,

greg k-h
