Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346AbaGNVat (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 17:30:49 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:60716 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757230AbaGNVao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 17:30:44 -0400
Message-ID: <1405373441.13661.33.camel@x220>
Subject: Re: [PATCH char-misc-next 2/2] dma: Fix MIC X100 DMA Driver Kconfig
 option
From: Paul Bolle <pebolle@tiscali.nl>
To: Sudeep Dutt <sudeep.dutt@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Siva Yerramreddy <yshivakrishna@gmail.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Nikhil Rao <nikhil.rao@intel.com>,
        Himangi Saraogi <himangi774@gmail.com>, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org
Date: Mon, 14 Jul 2014 23:30:41 +0200
In-Reply-To: <2eadff30dc5e9642b82f523c0398bf20109dd622.1405370827.git.sudeep.dutt@intel.com>
References: <cover.1405370827.git.sudeep.dutt@intel.com>
	 <2eadff30dc5e9642b82f523c0398bf20109dd622.1405370827.git.sudeep.dutt@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jul 2014 21:30:42.0513 (UTC) FILETIME=[DD6BF410:01CF9FAA]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-07-14 at 14:23 -0700, Sudeep Dutt wrote:
> Select DMA_ENGINE instead of DMAENGINE and delete the default
> line as the default is 'n' anyways.
> 
> Link: https://lkml.org/lkml/2014/7/14/90
> Reported-by: Paul Bolle <pebolle@tiscali.nl>
> Signed-off-by: Sudeep Dutt <sudeep.dutt@intel.com>

Thanks for picking this up!


Paul Bolle

