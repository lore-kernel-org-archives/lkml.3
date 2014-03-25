Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419AbaCYIMO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 04:12:14 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:51891 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbaCYIMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 04:12:12 -0400
MIME-Version: 1.0
In-Reply-To: <1395701191-1030-1-git-send-email-architekt@coding4coffee.org>
References: <1395696913.13968.67.camel@joe-AO722>
	<1395701191-1030-1-git-send-email-architekt@coding4coffee.org>
Date: Tue, 25 Mar 2014 09:12:11 +0100
Message-ID: <CAJSP0QX3_z0P6p3MRdm_7N7DAC5X=rmscW4=fmiiU55U9wB5xg@mail.gmail.com>
Subject: Re: [PATCH v2] staging: line6: Add blank lines after declarations
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Fabian Mewes <architekt@coding4coffee.org>
Cc: joe@perches.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ashvinivaratharaj@gmail.com, Chris <cbajumpa@gmail.com>,
        rashika.kheria@gmail.com, berardi.dav@gmail.com,
        monamagarwal123@gmail.com, lisa@xenapiadmin.com,
        ebru.akagunduz@gmail.com, Dan Carpenter <dan.carpenter@oracle.com>,
        devel@driverdev.osuosl.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2014 at 11:46 PM, Fabian Mewes
<architekt@coding4coffee.org> wrote:
> Use the more common kernel coding style.
>
> Signed-off-by: Fabian Mewes <architekt@coding4coffee.org>
> ---
> applies to next-20140324
> v1..v2: improve commit message as suggested by Joe
>
>  drivers/staging/line6/driver.c   | 1 +
>  drivers/staging/line6/playback.c | 5 +++++
>  drivers/staging/line6/toneport.c | 1 +
>  3 files changed, 7 insertions(+)

Reviewed-by: Stefan Hajnoczi <stefanha@gmail.com>
