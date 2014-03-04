Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304AbaCDNqF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 08:46:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39603 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757237AbaCDNqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 08:46:04 -0500
Date: Tue, 4 Mar 2014 14:46:01 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        David Barksdale <dbarksdale@uplogix.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] HID: cp2112: remove the last hid_output_raw_report()
 call
In-Reply-To: <1393633237-26496-3-git-send-email-benjamin.tissoires@redhat.com>
Message-ID: <alpine.LNX.2.00.1403041445080.30402@pobox.suse.cz>
References: <1393633237-26496-1-git-send-email-benjamin.tissoires@redhat.com> <1393633237-26496-3-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Feb 2014, Benjamin Tissoires wrote:

> I don't have access to the device, so I copied/pasted the code
> from hidraw.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
>  drivers/hid/hid-cp2112.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/hid/hid-cp2112.c b/drivers/hid/hid-cp2112.c
> index 860db694..c4f87bd 100644
> --- a/drivers/hid/hid-cp2112.c
> +++ b/drivers/hid/hid-cp2112.c
> @@ -290,7 +290,21 @@ static int cp2112_hid_output(struct hid_device *hdev, u8 *data, size_t count,
>  	if (!buf)
>  		return -ENOMEM;
>  
> -	ret = hdev->hid_output_raw_report(hdev, buf, count, report_type);
> +	/* Fixme: test which function is actually called for output reports */

I don't completely understand this Fixme (oh, and please spell it as 
'FIXME:' so that we are consistent with all the other instances), could 
you please elaborate?

Thanks,

-- 
Jiri Kosina
SUSE Labs
