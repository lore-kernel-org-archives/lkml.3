Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896AbbANNSm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 08:18:42 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:23332 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbbANNSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 08:18:41 -0500
Date: Wed, 14 Jan 2015 16:18:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Simone Weiss <simone.weiss@fau.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@i4.cs.fau.de,
        lidza.louina@gmail.com, driverdev-devel@linuxdriverproject.org,
        helene.gsaenger@studium.fau.de, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH v3 4/6] dgnc: checkpatch: macros in enclosed parantheses
Message-ID: <20150114131815.GG5571@mwanda>
References: <0141223162911.GB4273@kroah.com>
 <1421240913-32192-1-git-send-email-simone.weiss@fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421240913-32192-1-git-send-email-simone.weiss@fau.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 02:08:33PM +0100, Simone Weiss wrote:
> dpacompat.h and digi.h partly define the same macros, so it is necessary to
> change them both.
> 

Could we eliminate one define?  (I haven't looked so this isn't a
rhetorical question).

regards,
dan carpenter

