Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbaA3WYQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 17:24:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36818 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753278AbaA3WYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 17:24:13 -0500
Message-ID: <52EAD0F2.7090101@zytor.com>
Date: Thu, 30 Jan 2014 14:23:46 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alex Thorlton <athorlton@sgi.com>, Borislav Petkov <bp@alien8.de>
CC: Matt Fleming <matt@console-pimps.org>, Russ Anderson <rja@sgi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [BUG] Linux 3.14 fails to boot with new EFI changes
References: <52E2ADB1.2030007@zytor.com> <20140124183730.GC11788@pd.tnic> <20140124184842.GD11788@pd.tnic> <20140124191709.GT18196@sgi.com> <20140127222129.GK6839@pd.tnic> <20140128110552.GA815@pd.tnic> <20140128200754.GZ18196@sgi.com> <20140128225905.GN815@pd.tnic> <20140128234036.GB18196@sgi.com> <20140129141822.GC24887@pd.tnic> <20140130221950.GJ3105@sgi.com>
In-Reply-To: <20140130221950.GJ3105@sgi.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2014 02:19 PM, Alex Thorlton wrote:
> 
> The quick answer is I think it is a virtual address, because                                                                                                                                                                                                                                                                 
> it does not work in physical mode.  If you ever see "virtefi"                                                                                                                                                                                                                                                                
> on the RHEL bootline it is because RH switched the default                                                                                                                                                                                                                                                                   
> to physical mode, which caused UV to not boot.  "virtefi"                                                                                                                                                                                                                                                                    
> forced it back to virtual mode.
> 

That is interesting, as it is definitely not the direction we have been
going in within the Linux community.

	-hpa


