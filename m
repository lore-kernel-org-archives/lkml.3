Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600AbbAJEbm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 23:31:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40528 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbbAJEbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 23:31:41 -0500
Date: Fri, 9 Jan 2015 20:31:39 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: jitendra kumar khasdev <jkhasdev@gmail.com>
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6] Staging: comedi: patch to fix 80 characters line over
 warnings
Message-ID: <20150110043139.GA1985@kroah.com>
References: <1420863879-4066-1-git-send-email-jkhasdev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420863879-4066-1-git-send-email-jkhasdev@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2015 at 09:54:39AM +0530, jitendra kumar khasdev wrote:
> This is the patch to pcl812.c that fix 80 character line over warnings.
> These warnings are identified by checkpatch.pl tool.
> For this patch I have did following changes,
> 1. convert single line comment into multiline comment
> 2. provide tab sapce for indentation purpose
> 3. reduce extra space between ( = ) sign.

You did 3 things here, so make it 3 different patches please.

thanks,

greg k-h
