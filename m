Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055AbaJ1FZX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 01:25:23 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:40014 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbaJ1FZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 01:25:22 -0400
Date: Mon, 27 Oct 2014 22:25:17 -0700
From: Darren Hart <dvhart@infradead.org>
To: Frans Klaver <fransklaver@gmail.com>
Cc: Corentin Chary <corentin.chary@gmail.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] eeepc-laptop: clean up control flow in
 eeepc_acpi_notify
Message-ID: <20141028052517.GG60814@vmdeb7>
References: <1414005163-3461-1-git-send-email-fransklaver@gmail.com>
 <1414005163-3461-6-git-send-email-fransklaver@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414005163-3461-6-git-send-email-fransklaver@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 09:12:40PM +0200, Frans Klaver wrote:
> eeepc_acpi_notify increases the indentation level to a whopping four. If
> we revise the conditions a bit, we can reduce that to a more soothing
> two and satisfy the indentation guidelines in Documentation/CodingStyle.
> 
> Remove an unwanted space while we're in the neighbourhood.
> 
> Signed-off-by: Frans Klaver <fransklaver@gmail.com>
> ---
>  drivers/platform/x86/eeepc-laptop.c | 53 ++++++++++++++++++-------------------
>  1 file changed, 26 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
> index 73e8d39..21ffe1f 100644
> --- a/drivers/platform/x86/eeepc-laptop.c
> +++ b/drivers/platform/x86/eeepc-laptop.c
> @@ -1213,7 +1213,7 @@ static void eeepc_input_exit(struct eeepc_laptop *eeepc)
>  static void eeepc_input_notify(struct eeepc_laptop *eeepc, int event)
>  {
>  	if (!eeepc->inputdev)
> -		return ;
> +		return;
>  	if (!sparse_keymap_report_event(eeepc->inputdev, event, 1, true))
>  		pr_info("Unknown key %x pressed\n", event);
>  }
> @@ -1222,6 +1222,7 @@ static void eeepc_acpi_notify(struct acpi_device *device, u32 event)
>  {
>  	struct eeepc_laptop *eeepc = acpi_driver_data(device);
>  	u16 count;
> +	int old_brightness, new_brightness;


Variable declarations in order of decreasing line length please.

Otherwise, looks good. Mind sending an update of this one?

-- 
Darren Hart
Intel Open Source Technology Center
