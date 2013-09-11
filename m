Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab3IKPxx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 11:53:53 -0400
Received: from sw.attotech.com ([208.69.85.34]:64015 "EHLO
	NOTESERV1.attotech.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754309Ab3IKPxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 11:53:52 -0400
X-Greylist: delayed 903 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Sep 2013 11:53:52 EDT
Message-ID: <52308E83.3090905@attotech.com>
Date: Wed, 11 Sep 2013 11:38:43 -0400
From: Bradley Grove <bgrove@attotech.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Bradley Grove <linuxdrivers@attotech.com>
Subject: Re: [PATCH] scsi: esas2r: fix potential format string flaw
References: <20130911043848.GA17221@www.outflux.net>
In-Reply-To: <20130911043848.GA17221@www.outflux.net>
X-MIMETrack: Itemize by SMTP Server on NOTESERV2/SERV/ATTO(Release 9.0|March 08, 2013) at
 09/11/2013 11:38:48 AM,
	Serialize by Router on NOTESERV1/SERV/ATTO(Release 9.0|March 08, 2013) at
 09/11/2013 11:53:52 AM,
	Serialize complete at 09/11/2013 11:53:52 AM
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2013 12:38 AM, Kees Cook wrote:
> This makes sure format strings cannot leak into the printk call via the
> constructed buffer.
>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---

Acked-by: Bradley Grove <bgrove@attotech.com>

Brad


