Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099Ab3FYNdB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 09:33:01 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:49960 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab3FYNc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 09:32:58 -0400
Date: Tue, 25 Jun 2013 16:32:45 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Dave Chinner <david@fromorbit.com>
Cc: g@dastard, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] vfs: check for integer overflows in posix_acl_alloc()
Message-ID: <20130625133245.GI5714@mwanda>
References: <20130624162719.GB32503@elgon.mountain>
 <20130624213709.GT29338@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130624213709.GT29338@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yeah.  You're right.  When I look at it more closely the ext4
example is capped ext4_get_acl().  Sorry for the noise.

regards,
dan carpenter

