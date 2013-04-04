Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765347Ab3DDWhj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 18:37:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59433 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765154Ab3DDWhh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 18:37:37 -0400
Date: Fri, 5 Apr 2013 00:37:36 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jiri Slaby <jslaby@suse.cz>
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 5/5] HID: hid-lenovo-tpkbd, remove doubled
 hid_get_drvdata
In-Reply-To: <1365107532-32721-5-git-send-email-jslaby@suse.cz>
Message-ID: <alpine.LNX.2.00.1304050037250.16378@pobox.suse.cz>
References: <1365107532-32721-1-git-send-email-jslaby@suse.cz> <1365107532-32721-5-git-send-email-jslaby@suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Apr 2013, Jiri Slaby wrote:

> In pointer_press_speed_show, we do
>     data_pointer = hid_get_drvdata(hdev);
> twice in a row. Remove one of those.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Jiri Kosina <jkosina@suse.cz>
> Cc: linux-input@vger.kernel.org
> ---
>  drivers/hid/hid-lenovo-tpkbd.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/hid/hid-lenovo-tpkbd.c b/drivers/hid/hid-lenovo-tpkbd.c
> index a0535fd..07837f5 100644
> --- a/drivers/hid/hid-lenovo-tpkbd.c
> +++ b/drivers/hid/hid-lenovo-tpkbd.c
> @@ -228,8 +228,6 @@ static ssize_t pointer_press_speed_show(struct device *dev,
>  	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
>  	struct tpkbd_data_pointer *data_pointer = hid_get_drvdata(hdev);
>  
> -	data_pointer = hid_get_drvdata(hdev);
> -

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
