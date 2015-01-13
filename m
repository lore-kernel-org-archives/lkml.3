Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905AbbAMF7S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 00:59:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39987 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbbAMF7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 00:59:14 -0500
Date: Mon, 12 Jan 2015 19:36:40 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: sunwxg <sun.wxg@gmail.com>
Cc: Forest Bond <forest@alittletooquiet.net>,
        Guido =?iso-8859-1?Q?Mart=EDnez?= <guido@vanguardiasur.com.ar>,
        Silvio Fricke <silvio.fricke@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging:vt6655 Add extern variable in head file
Message-ID: <20150113033640.GB31093@kroah.com>
References: <1418715590-10074-2-git-send-email-sun.wxg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418715590-10074-2-git-send-email-sun.wxg@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 03:39:50PM +0800, sunwxg wrote:
> From: Sun Wang <sun.wxg@gmail.com>
> 
> Subject: [PATCH] staging:vt6655 Add extern variable in head file

Why is this in the middle of the patch?  I would have to hand edit it
out :(

> 
> Extern variable must be declared in head file. Compiler can catch the inconsistency when variable changes. 

Always wrap your changelog at 72 columns.

Please fix up and resend.

thanks,

greg k-h
