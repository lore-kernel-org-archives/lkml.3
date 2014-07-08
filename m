Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970AbaGHJ1d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 05:27:33 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:25662 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbaGHJ1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 05:27:30 -0400
Date: Tue, 8 Jul 2014 12:27:09 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Dexuan Cui <decui@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, plagnioj@jcrosoft.com,
        tomi.valkeinen@ti.com, linux-fbdev@vger.kernel.org, olaf@aepfle.de,
        apw@canonical.com, jasowang@redhat.com, haiyangz@microsoft.com
Subject: Re: [PATCH v2] video: hyperv: hyperv_fb: refresh the VM screen by
 force on VM panic
Message-ID: <20140708092709.GI25880@mwanda>
References: <1403818501-15547-1-git-send-email-decui@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403818501-15547-1-git-send-email-decui@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't use likely/unlikely unless you have benchmark numbers to show that
it makes a speed up.

regards,
dan carpenter

