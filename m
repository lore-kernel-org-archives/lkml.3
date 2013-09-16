Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751651Ab3IPWx0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 18:53:26 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:31528 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab3IPWxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 18:53:25 -0400
Date: Tue, 17 Sep 2013 01:49:39 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mike Snitzer <snitzer@redhat.com>
Cc: Akira Hayakawa <ruby.wktk@gmail.com>, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, agk@redhat.com, joe@perches.com,
        akpm@linux-foundation.org, cesarb@cesarb.net, m.chehab@samsung.com
Subject: Re: staging: Add dm-writeboost
Message-ID: <20130916224939.GT25896@mwanda>
References: <5223208D.4000008@gmail.com>
 <20130916215357.GA5015@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130916215357.GA5015@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 05:53:57PM -0400, Mike Snitzer wrote:
> - variable names need to be a bit more verbose (arr => array)

"struct array " is a horrible name.  :P  Please don't use either "arr"
or "array".

regards,
dan carpenter

