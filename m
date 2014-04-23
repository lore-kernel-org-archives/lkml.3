Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974AbaDWDb0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 23:31:26 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:49139 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874AbaDWDbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 23:31:25 -0400
MIME-Version: 1.0
In-Reply-To: <20140422103510.GI26890@mwanda>
References: <1397983638-10752-1-git-send-email-navin.patidar@gmail.com>
	<1397983638-10752-9-git-send-email-navin.patidar@gmail.com>
	<20140422103510.GI26890@mwanda>
Date: Wed, 23 Apr 2014 09:01:24 +0530
Message-ID: <CAPV97ye8Y8egJD7=hDoWHFyAL_iUm3u3d9Nbqi9foxcYPPt8SQ@mail.gmail.com>
Subject: Re: [PATCH 09/10] staging: rtl8188eu: Remove unused enum
 LED_STATE_871x members.
From: navin patidar <navin.patidar@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Larry.Finger@lwfinger.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dan, It is ok to rearrange and remove members of  enum LED_STATE_871x
and  enum LED_CTL_MODE.
these enum are not related to firmware .

regards,
--navin-patidar

On Tue, Apr 22, 2014 at 4:05 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> It's ok to renumber all of these?  It's not something the firmware will
> care about?  Have you tested this?  Same for patch 10/10.
>
> (These questions are just questions.  I don't ask rhetorical questions
> on email.  I don't know the answers).
>
> regards,
> dan carpenter
>
