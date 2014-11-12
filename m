Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbaKLQny (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 11:43:54 -0500
Received: from mx02.posteo.de ([89.146.194.165]:55857 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753149AbaKLQnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 11:43:53 -0500
Message-ID: <54638DD6.60009@posteo.de>
Date: Wed, 12 Nov 2014 17:41:58 +0100
From: Martin Kepplinger <martink@posteo.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: miklos@szeredi.hu
CC: fuse-devel@lists.sourceforge.net, thierry.reding@gmail.com,
        gregkh@linuxfoundation.org, giedriuswork@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fuse: don't check for file->private_data on open().
References: <20141112112643.GA30821@ulmo.nvidia.com> <1415809894-24084-1-git-send-email-martink@posteo.de>
In-Reply-To: <1415809894-24084-1-git-send-email-martink@posteo.de>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2014-11-12 um 17:31 schrieb Martin Kepplinger:
> The miscdevice core now sets file->private_data to the struct miscdevice
> so don't fail when this is not NULL.
> 
> Reported-by: Thierry Reding <thierry.reding@gmail.com>
> Signed-off-by: Martin Kepplinger <martink@posteo.de>
> ---
> This is a question: what does this check provide and does overwriting
> file->private_data make any difference?
> 
> Is open() by the user not allowed here, if file->private_data is set?
> 
> thanks!!
> 

if ok, please add

Reported-by: Giedrius Statkevicius <giedriuswork@gmail.com>

thanks
