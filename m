Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187Ab3GaGKT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 02:10:19 -0400
Received: from vs15.mail.saunalahti.fi ([62.142.117.202]:54586 "EHLO
	vs15.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754401Ab3GaGKR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 02:10:17 -0400
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Jul 2013 02:10:17 EDT
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: [PATCH 26/36] SCSI: st: convert class code to use dev_groups
From: =?windows-1252?Q?Kai_M=E4kisara?= <Kai.Makisara@kolumbus.fi>
In-Reply-To: <1374703539-9705-27-git-send-email-gregkh@linuxfoundation.org>
Date: Wed, 31 Jul 2013 09:03:59 +0300
Cc: linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <6739E18D-CC83-4818-8524-4F65D715581B@kolumbus.fi>
References: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org> <1374703539-9705-27-git-send-email-gregkh@linuxfoundation.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.1508)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 25.7.2013, at 1.05, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> The dev_attrs field of struct class is going away soon, dev_groups
> should be used instead.  This converts the scsi tape class code to use
> the correct field.
> 
> Cc: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
> Cc: James E.J. Bottomley <JBottomley@parallels.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Acked-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>

> 
> James, feel free to take this through your tree, or ACK it and I can
> take it through mine.
> 
> drivers/scsi/st.c | 27 ++++++++++++++++-----------
> 1 file changed, 16 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> index 2a32036a..ff44b3c2 100644
> --- a/drivers/scsi/st.c
> +++ b/drivers/scsi/st.c
> @@ -82,7 +82,7 @@ static int try_rdio = 1;
> static int try_wdio = 1;
> 
…

Thanks,
Kai

