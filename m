Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932809AbaE2VuR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 17:50:17 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:40344 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754728AbaE2VuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 17:50:16 -0400
Date: Fri, 30 May 2014 00:48:52 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: navin patidar <navin.patidar@gmail.com>
Cc: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/18] staging: rtl8188eu: Remove "silentreset_mutex"
 from struct sreset_priv
Message-ID: <20140529214852.GD15585@mwanda>
References: <1401385858-28722-1-git-send-email-navin.patidar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401385858-28722-1-git-send-email-navin.patidar@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have reviewed this patchset.

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

Btw, I wish you would fold some of these patches together next time.
For example, patches 3-6 are very closely related and they should have
just been one thing.

Or the times where the change log says, "I am going to delete function
frob_frob_frob_whatever() in the next patch."  Just delete it in that
patch.

But anyway, you're doing a great job.  Very nice clean ups.

regards,
dan carpenter

