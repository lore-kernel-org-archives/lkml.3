Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763AbaJNHBL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 03:01:11 -0400
Received: from filter1.ibarracuda.nl ([83.247.7.10]:49957 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbaJNHBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 03:01:10 -0400
X-ASG-Debug-ID: 1413270052-0759e7482876fee0002-xx1T2L
X-Barracuda-Envelope-From: Frans.Klaver@xsens.com
X-Barracuda-AUTH-User: xsenscom
X-Barracuda-Apparent-Source-IP: 87.249.116.215
Date: Tue, 14 Oct 2014 09:00:12 +0200
From: Frans Klaver <frans.klaver@xsens.com>
To: Jiri Kosina <jkosina@suse.cz>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gadget_configfs.txt: fix spelling of 'function'
Message-ID: <20141014070012.GC25389@ci00147.xsens-tech.local>
X-ASG-Orig-Subj: Re: [PATCH] gadget_configfs.txt: fix spelling of 'function'
References: <1412170231-30936-1-git-send-email-frans.klaver@xsens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1412170231-30936-1-git-send-email-frans.klaver@xsens.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [172.16.11.125]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1413270052
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://filter1.ibarracuda.nl:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.10548
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2014 at 03:30:31PM +0200, Frans Klaver wrote:
> Signed-off-by: Frans Klaver <frans.klaver@xsens.com>
> ---
>  Documentation/usb/gadget_configfs.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/usb/gadget_configfs.txt b/Documentation/usb/gadget_configfs.txt
> index 4cf53e4..635e574 100644
> --- a/Documentation/usb/gadget_configfs.txt
> +++ b/Documentation/usb/gadget_configfs.txt
> @@ -376,7 +376,7 @@ functions and binds them. This way the whole gadget is bound.
>  configured, so config_groups for particular functions are defined
>  in the functions implementation files drivers/usb/gadget/f_*.c.
>  
> -5. Funciton's code is written in such a way that it uses
> +5. Function's code is written in such a way that it uses
>  
>  usb_get_function_instance(), which, in turn, calls request_module.
>  So, provided that modprobe works, modules for particular functions
> -- 
> 2.1.0
> 

Ping
