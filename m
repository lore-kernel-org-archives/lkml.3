Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370AbaLCFZ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 00:25:58 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:45185 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbaLCFZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 00:25:57 -0500
Date: Tue, 2 Dec 2014 15:04:27 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Athira Sharikkal <athirasnamby@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Drivers: input: mousedev.c: Fixed trailing statement
 on the next line
Message-ID: <20141202230427.GA6207@localhost>
References: <1417437402-3365-1-git-send-email-athirasnamby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417437402-3365-1-git-send-email-athirasnamby@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Athira,

On Mon, Dec 01, 2014 at 06:06:42PM +0530, Athira Sharikkal wrote:
> Fixed checkpatch error:
> trailing statements should be on next line
> 
> Signed-off-by: Athira Sharikkal <athirasnamby@gmail.com>
> ---
> v2: corrected indentation
>  drivers/input/mousedev.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/input/mousedev.c b/drivers/input/mousedev.c
> index b604564..28988f5 100644
> --- a/drivers/input/mousedev.c
> +++ b/drivers/input/mousedev.c
> @@ -248,7 +248,8 @@ static void mousedev_key_event(struct mousedev *mousedev,
>  	case BTN_4:
>  	case BTN_EXTRA:		index = 4; break;
>  
> -	default:		return;
> +	default:	
> +				return;

Changing one bit in a file while leaving the rest of it unchanged does not
make much sense. That said, I believe that in this particular case the
original style is fine and does not need changing.

Thanks.

-- 
Dmitry
