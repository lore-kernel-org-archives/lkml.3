Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363AbaILIgu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 04:36:50 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:33121 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbaILIgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 04:36:49 -0400
Date: Fri, 12 Sep 2014 11:36:27 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: micky_ching@realsil.com.cn
Cc: sameo@linux.intel.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, wei_wang@realsil.com.cn,
        devel@linuxdriverproject.org, rogerable@realtek.com,
        lee.jones@linaro.org
Subject: Re: [PATCH 1/2] mfd: rtsx: fix PM suspend for 5227
Message-ID: <20140912083627.GX6600@mwanda>
References: <cover.1410330111.git.micky_ching@realsil.com.cn>
 <c13c93e9f5fca1a46df2b141899d50c13b28aaa0.1410330111.git.micky_ching@realsil.com.cn>
 <20140911074249.GW6600@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140911074249.GW6600@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 10:42:49AM +0300, Dan Carpenter wrote:
> On Thu, Sep 11, 2014 at 03:17:52PM +0800, micky_ching@realsil.com.cn wrote:
> > +	err = pci_read_config_byte(pcr->pci, addr, &val);
> > +	if (err)
> > +		return err;
> 
> Some of these check for "if (err) " and some check for "if (err < 0) ".
> What is the significance of that?  I'm a newbie here.  Did you mean for
> them to be different?

You've updated them all to be "if (err < 0)" how is that different from
"if (err)"?  What I'm saying is that could you reply to the question?

I guess I normally prefer "if (err)" over "if (err < 0)" but I don't
know if it makes a difference here?

regards,
dan carpenter
>
