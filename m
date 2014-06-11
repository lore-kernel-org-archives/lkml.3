Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343AbaFKENZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 00:13:25 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:36839 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaFKENY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 00:13:24 -0400
MIME-Version: 1.0
In-Reply-To: <20140610072824.GH5500@mwanda>
References: <1402071320-14400-1-git-send-email-navin.patidar@gmail.com>
	<1402071320-14400-5-git-send-email-navin.patidar@gmail.com>
	<20140610072824.GH5500@mwanda>
Date: Wed, 11 Jun 2014 09:43:23 +0530
Message-ID: <CAPV97ycVfL7HLfQpPUx9jnhWn51MpdEt7xH=duKp60Fnv3kOyw@mail.gmail.com>
Subject: Re: [PATCH 06/13] staging: rtl8188eu: Remove unused funtion _rtw_read_mem()
From: navin patidar <navin.patidar@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

some times i get confused by one patch should do only one thing
policy, for example this patch removes
many other things along  _rtw_read_mem().
But you are also right it's much easier to review when they are all
folded together.
I'm glad, i did it right this time. :)

regards,
navin patidar

On Tue, Jun 10, 2014 at 12:58 PM, Dan Carpenter
<dan.carpenter@oracle.com> wrote:
> Thanks.  This is much nicer to review when they are all folded together
> like this.
>
> regards,
> dan carpenter
>
