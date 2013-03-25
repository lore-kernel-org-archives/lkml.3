Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759092Ab3CYXcR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 19:32:17 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:49092 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584Ab3CYXcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 19:32:15 -0400
Date: Mon, 25 Mar 2013 16:32:13 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        "nico@linaro.org" <nico@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] include/linux/platform_data: beautify code, 'inline' is
 better in front of 'void'
Message-ID: <20130325233213.GA29245@kroah.com>
References: <514FB826.9020302@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <514FB826.9020302@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 25, 2013 at 10:36:22AM +0800, Chen Gang wrote:
> 
>   better to let 'inline' in front of 'void'

Why?  What does this fix?

