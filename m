Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759939Ab3HOTyI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 15:54:08 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:54504 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756958Ab3HOTyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 15:54:07 -0400
MIME-Version: 1.0
In-Reply-To: <20130812210720.GA10370@kroah.com>
References: <1375650256-12411-1-git-send-email-jfrederich@gmail.com>
	<20130812210720.GA10370@kroah.com>
Date: Thu, 15 Aug 2013 21:54:05 +0200
Message-ID: <CAF92urqkWhXO0_DiFG5hp4qDXLYEoATrrvOw-JXQvWvHQp3QDQ@mail.gmail.com>
Subject: Re: [PATCH] Staging: olpc_dcon: more big endian conformity
From: Jens Frederich <jfrederich@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, Jon Nettleton <jon.nettleton@gmail.com>,
        Daniel Drake <dsd@laptop.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 11:07 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Sun, Aug 04, 2013 at 11:04:16PM +0200, Jens Frederich wrote:
>> Using an int which is casted to unsigned char as inbuf is messy.
>> The code won't work on big endian systems.  The patch should fix
>> this.
>>
>> Signed-off-by: Jens Frederich <jfrederich@gmail.com>
>
> This patch doesn't apply at all, can you refresh it against my
> staging-next branch and resend it so that I can apply it?
>

Sorry for the duplicated patch 3.  The subject:
[PATCH] Staging: olpc_dcon: more big endian conformity and
[PATCH 3/3] Staging: olpc_dcon: more big endian conformity
is equal for the Google mail client and lands in the same
thread.  I'd use Mutt.

thanks,
jens
