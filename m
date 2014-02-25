Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbaBYQKY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 11:10:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58364 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269AbaBYQKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 11:10:22 -0500
Date: Tue, 25 Feb 2014 08:11:56 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim McDonough <jmcd@samba.org>, Jeff Layton <jlayton@redhat.com>,
        David Disseldorp <ddiss@samba.org>, Steve French <smfrench@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Stable backport of cifs nlink workaround?
Message-ID: <20140225161156.GA27235@kroah.com>
References: <20140225152443.GA15552@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140225152443.GA15552@sucs.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 03:24:43PM +0000, Sitsofe Wheeler wrote:
> Hi,
> 
> Is there any chance that 74d290da476f672ad756634d12aa707375d3564d
> ([CIFS] Provide sane values for nlink) could be backported to the stable
> 3.2 kernel?

Why just 3.2?  What's wrong with all of the other kernels before 3.12
that do not have this patch in it?

thanks,

greg k-h
