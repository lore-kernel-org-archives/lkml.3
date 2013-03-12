Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791Ab3CLXGK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 19:06:10 -0400
Received: from mail-ia0-f170.google.com ([209.85.210.170]:52873 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304Ab3CLXGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 19:06:07 -0400
Date: Tue, 12 Mar 2013 16:06:04 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Larry Baker <baker@usgs.gov>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Miller <davem@redhat.com>
Subject: Re: [ 20/21] decnet: Fix disappearing sysctl entries
Message-ID: <20130312230604.GA3728@kroah.com>
References: <20130312223245.109098379@linuxfoundation.org>
 <20130312223247.449652622@linuxfoundation.org>
 <B401117D-23F6-4911-8D72-344EE1A022F6@usgs.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B401117D-23F6-4911-8D72-344EE1A022F6@usgs.gov>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 03:52:19PM -0700, Larry Baker wrote:
> Greg,
> 
> Will there also be a 2.6-stable patch (Eric's first submission)?  My CentOS 6.3
> systems still use 2.6 kernels.

I do not maintain any 2.6-stable releases, sorry.  I suggest you work
with Centos to get this patch into their kernel as soon as possible, as
I do not know when the next 2.6-stable kernel will be released.

thanks,

greg k-h
