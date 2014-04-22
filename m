Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993AbaDVPNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 11:13:22 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:53601 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756896AbaDVPNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 11:13:16 -0400
Message-ID: <1398179539.4724.168.camel@iivanov-dev>
Subject: Re: [PATCH v6 03/19] usb: phy: msm: Move global regulators
 variables to driver state
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: balbi@ti.com
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Date: Tue, 22 Apr 2014 18:12:19 +0300
In-Reply-To: <20140422145745.GJ5524@saruman.home>
References: <1398158438-21579-1-git-send-email-iivanov@mm-sol.com>
	 <1398158438-21579-4-git-send-email-iivanov@mm-sol.com>
	 <20140422145745.GJ5524@saruman.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.1-2ubuntu2~saucy1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-22 at 09:57 -0500, Felipe Balbi wrote:
> On Tue, Apr 22, 2014 at 12:20:22PM +0300, Ivan T. Ivanov wrote:
> > From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> 
> #define ENOLOG		ENOCOMMIT
> 
> return -ENOLOG;
> 

#if SIMPLE_CHANGE
#define ENOLOG		0
#endif

Will fix it :-)

Ivan

