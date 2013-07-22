Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368Ab3GVGWi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 02:22:38 -0400
Received: from gir.skynet.ie ([193.1.99.77]:53807 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754495Ab3GVGWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 02:22:37 -0400
Date: Mon, 22 Jul 2013 07:22:32 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: drmichaelschuster@web.de
cc: linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Alex Deucher <alexdeucher@gmail.com>
Subject: Re: PATCH - RADEON patch update for 3.10.1 urgency low
In-Reply-To: <trinity-67fedd9d-eb7a-45b7-9151-59de752382c0-1374435040638@3capp-webde-bs05>
Message-ID: <alpine.DEB.2.00.1307220721420.2131@skynet.skynet.ie>
References: <trinity-67fedd9d-eb7a-45b7-9151-59de752382c0-1374435040638@3capp-webde-bs05>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1045233769-1374474152=:2131"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1045233769-1374474152=:2131
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT


> did some re-design of the patch for detecting power modes in PowerPlayTable,
> I
> hope this version looks a little bit smarter. Quality check with my muxless
> HD 6490M
> succesful, integrity/sanity checks for other asics like si/r600 which use
> the
> radeon_atombios_parse_power_table_4_5 are to be done.
>  
> Best wishes and regards,
>  
> Michael Schuster

Hi,

I've cc'ed the lists, and Alex the radeon maintainer.


Dave.

--29444707-1045233769-1374474152=:2131--
