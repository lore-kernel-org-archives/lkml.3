Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbaEDHqG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 03:46:06 -0400
Received: from smtp44.i.mail.ru ([94.100.177.104]:49040 "EHLO smtp44.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753258AbaEDHqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 03:46:05 -0400
X-Greylist: delayed 146935 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 May 2014 03:46:04 EDT
Date: Sun, 4 May 2014 11:46:00 +0400
From: Brilliantov Kirill Vladimirovich <brilliantov@inbox.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/comedi: fix sparse warning: shift too big
Message-ID: <20140504074600.GA3010@kirill.netbynet.ru>
Mail-Followup-To: Brilliantov Kirill Vladimirovich <brilliantov@inbox.ru>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ian Abbott <abbotti@mev.co.uk>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	linux-kernel@vger.kernel.org
References: <1399042624-9441-1-git-send-email-brilliantov@inbox.ru>
 <20140503235838.GA20243@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140503235838.GA20243@kroah.com>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-05-03 19:58:38, Greg Kroah-Hartman wrote:
> 
> That change does nothing, so it's not worth applying, don't you agree?
> 

You right, this patch is not very useful.
