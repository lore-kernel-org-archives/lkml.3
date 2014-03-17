Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751120AbaCQTGF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 15:06:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47136 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbaCQTGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 15:06:03 -0400
Date: Mon, 17 Mar 2014 12:08:03 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Davide Berardi <berardi.dav@gmail.com>
Cc: joe@perches.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fixing some coding style issues on line6 driver.c
Message-ID: <20140317190803.GA18344@kroah.com>
References: <20140316132016.388a3f69@White-Rabbit>
 <20140316163700.GA1781@kroah.com>
 <1394988926.5689.39.camel@joe-AO722>
 <20140317033441.125d2212@White-Rabbit>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140317033441.125d2212@White-Rabbit>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 03:34:41AM +0100, Davide Berardi wrote:
> Thanks for your replies, I've applied your suggestions to the patch.
> 
> Davide
> 
> Fixed some line over 80 characters.
> 
> From: Davide Berardi <berardi.dav@gmail.com>
> 
> Signed-off-by: Davide Berardi <berardi.dav@gmail.com>

In the future, you should do this as:
	Subject: [PATCH v2] ....

and don't put a response in the body, as I have to hand-edit it to fix
this up...

I'll do it this time,

greg k-h
