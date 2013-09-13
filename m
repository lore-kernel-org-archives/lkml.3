Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791Ab3IMRBI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 13:01:08 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58613 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310Ab3IMRBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 13:01:07 -0400
Message-ID: <523344C7.60303@kernel.dk>
Date: Fri, 13 Sep 2013 11:00:55 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Jeff Moyer <jmoyer@redhat.com>,
        Ramprasad Chinthekindi <rchinthekindi@stec-inc.com>,
        Akhil Bhansali <abhansali@stec-inc.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch 1/4] skd: use regular version of copy_from_user()
References: <20130913075523.GE19211@elgon.mountain>
In-Reply-To: <20130913075523.GE19211@elgon.mountain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2013 01:55 AM, Dan Carpenter wrote:
> The other __copy_from_user() calls have access_ok() checks so they are
> fine, but these two don't have the check.

Thanks Dan, applied this one and the other two. Did you miss sending one
out? I don't see a 3/4 patch.

-- 
Jens Axboe

