Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751336AbaEWUIS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 16:08:18 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:45764 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaEWUIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 16:08:17 -0400
MIME-Version: 1.0
In-Reply-To: <20140523111454.GA3992@kroah.com>
References: <1400819147-14236-1-git-send-email-matlackdavid@gmail.com> <20140523111454.GA3992@kroah.com>
From: David Matlack <matlackdavid@gmail.com>
Date: Fri, 23 May 2014 13:07:55 -0700
Message-ID: <CANoiuG+5qYQkgmzPXoCTMY9C5Z3P0_K-rXHjN3k50CJhv+E5Qw@mail.gmail.com>
Subject: Re: [PATCH] staging: slicoss: fix use-after-free in slic_entry_probe
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, charrer@alacritech.com,
        linux-kernel@vger.kernel.org, Lior Dotan <liodot@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 4:14 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> I think I've already applied all of these, if not, please let me know.
>
> Also, you forgot to number these patches to let me know what order to
> apply them in :(
>
> thanks,
>
> greg k-h

Thanks Greg. Sorry for the confusion. I resent these patches without numbers
because in retrospect, they were all independent changes and could be applied
in any order. In retro-retrospect, that probably just piled onto the confusion
:)

Looking at the emails I got from you about staging-next, _almost_ all the
patches were applied. I reply to the ones directly that were dropped.

Thanks!
