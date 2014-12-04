Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbaLDVNV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 16:13:21 -0500
Received: from na6sys009bog010.obsmtp.com ([74.125.150.60]:34738 "HELO
	na6sys009bog010.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754630AbaLDVNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 16:13:20 -0500
MIME-Version: 1.0
In-Reply-To: <1417720816.2404.11.camel@jtkirshe-mobl>
References: <1417718366-14310-1-git-send-email-joestringer@nicira.com>
 <5480B1F0.9090407@cogentembedded.com> <1417720816.2404.11.camel@jtkirshe-mobl>
From: Joe Stringer <joestringer@nicira.com>
Date: Thu, 4 Dec 2014 13:12:58 -0800
Message-ID: <CANr6G5zcPEZPWktNK3N2aCHma-o3_o1hvBzGeZ=nYQi5ijTheA@mail.gmail.com>
Subject: Re: [linux-nics] [PATCHv3 net] i40e: Implement ndo_gso_check()
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Linux Netdev List <netdev@vger.kernel.org>,
        "linux.nics" <linux.nics@intel.com>, Jesse Gross <jesse@nicira.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Tom Herbert <therbert@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> > +#define MAX_TUNNEL_HDR_LEN 80
>>
>>     I'd #define this just above the function, if not at the start of the file...

Right, the style for most of this file is to place the #define like
this above the function. I'll do that.
