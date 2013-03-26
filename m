Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759164Ab3CZBse (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 21:48:34 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:33066 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202Ab3CZBsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 21:48:32 -0400
Date: Mon, 25 Mar 2013 18:48:30 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        "nico@linaro.org" <nico@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] include/linux/platform_data: beautify code, 'inline' is
 better in front of 'void'
Message-ID: <20130326014830.GB6496@kroah.com>
References: <514FB826.9020302@asianux.com>
 <20130325233213.GA29245@kroah.com>
 <5150F871.5050306@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5150F871.5050306@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 09:22:57AM +0800, Chen Gang wrote:
> On 2013年03月26日 07:32, Greg KH wrote:
> > On Mon, Mar 25, 2013 at 10:36:22AM +0800, Chen Gang wrote:
> >>
> >>   better to let 'inline' in front of 'void'
> > 
> > Why?  What does this fix?
> > 
> > 
> > 
> 
>   when I am compiling with "EXTRA_FLAGS=-W", I get a warning:

That's not anything I really care about, sorry.  No one sane builds the
kernel like that :)

greg k-h
