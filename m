Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779Ab3HVSFF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 14:05:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44539 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab3HVSFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 14:05:04 -0400
Date: Thu, 22 Aug 2013 11:05:03 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: =?utf-8?B?0KDRg9GB0YLQsNGE0LAg0JTQttCw0LzRg9GA0LDRhdC80LXRgtC+0LI=?= 
	<drustafa@yandex.ru>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/11] w1: add attribute groups to struct w1_family_ops
Message-ID: <20130822180503.GA19753@kroah.com>
References: <1377125105-25388-1-git-send-email-gregkh@linuxfoundation.org>
 <267911377129904@web1d.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <267911377129904@web1d.yandex.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 04:05:04AM +0400, Рустафа Джамурахметов wrote:
> Hi
> 
> 22.08.2013, 02:45, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>:
> > This lets w1 slave drivers declare an attribute group, and not have to
> > create/destroy sysfs files directly.  All w1 slave drivers will be fixed
> > to use this field up in follow-on patches to this one.
> 
> Sounds reasonble, saves fair amount of code in w1 drivers

Thanks for reviewing it.

greg k-h
