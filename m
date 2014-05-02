Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655AbaEBFtJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 01:49:09 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:42865 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329AbaEBFtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 01:49:08 -0400
Message-ID: <1399009745.5109.0.camel@violet>
Subject: Re: [PATCH v7 16/20] usb: phy: msm: Fix PTS definitions for MSM USB
 controller
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: balbi@ti.com
Cc: Tim Bird <tbird20d@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Tim Bird <tim.bird@sonymobile.com>
Date: Fri, 02 May 2014 08:49:05 +0300
In-Reply-To: <20140430162705.GL23679@saruman.home>
References: <1398354495-20782-1-git-send-email-iivanov@mm-sol.com>
	 <1398354495-20782-17-git-send-email-iivanov@mm-sol.com>
	 <20140430162705.GL23679@saruman.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-30 at 11:27 -0500, Felipe Balbi wrote:
> On Thu, Apr 24, 2014 at 06:48:11PM +0300, Ivan T. Ivanov wrote:
> > From: Tim Bird <tbird20d@gmail.com>
> > 
> > Fix the value used for Parallel Transceiver Select (PTS) for the MSM USB
> > controller.  This is a standard chipidea PORTSC definition, where
> > a PHY_TYPE of 10b (<<30) is ULPI and 11b (<<30) is SERIAL.
> > Fix the definitions and use them correctly in the driver code.
> > 
> > Signed-off-by: Tim Bird <tim.bird@sonymobile.com>
> 
> since you're the one sending the patch, you must add your signed-off-by
> too. If you reply with your SoB I'll add to proper patches.
> 

Sure. 

Signed-of-by: Ivan T. Ivanov <iivanov@mm-sol.com>

Thanks.


