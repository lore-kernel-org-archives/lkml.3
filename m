Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968199AbaLLNxI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 08:53:08 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:49171 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967949AbaLLNxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 08:53:05 -0500
MIME-Version: 1.0
In-Reply-To: <548AEE11.50303@xs4all.nl>
References: <1415218274-28132-1-git-send-email-andrey.utkin@corp.bluecherry.net>
	<548AEE11.50303@xs4all.nl>
Date: Fri, 12 Dec 2014 15:53:04 +0200
Message-ID: <CAM_ZknU_5MYEkC7VTD3-M1vcvqoTXtg-Dy-iozpky0TSOymEgQ@mail.gmail.com>
Subject: Re: [PATCH] solo6x10: just pass frame motion flag from hardware, drop
 additional handling as complicated and unstable
From: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-kernel@vger.kernel.org, Linux Media <linux-media@vger.kernel.org>,
        m.chehab@samsung.com, "hans.verkuil" <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 3:30 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
>
> I have tested this and it looks good. I am not sure what problems I had
> originally that caused me to write that code, since it is now functioning
> as expected.
>
> So you can expect this patch to be part of the next 3.20 pull request I'll
> post.
>
> Sorry for the delay.

Thanks.

-- 
Bluecherry developer.
