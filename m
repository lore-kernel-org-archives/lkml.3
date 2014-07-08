Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688AbaGHF7h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 01:59:37 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:24380 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbaGHF7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 01:59:36 -0400
Date: Tue, 8 Jul 2014 08:59:20 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        "Chen, Gong" <gong.chen@linux.intel.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] video: fbdev: sis: init.c:  Cleaning up variable that
 is never used
Message-ID: <20140708055919.GP25934@mwanda>
References: <1404764628-25192-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404764628-25192-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2014 at 10:23:47PM +0200, Rickard Strandqvist wrote:
> Variable ar assigned a value that is never used.
> I have also removed all the code that thereby serves no purpose.
> 
> This was found using a static code analysis program called cppcheck
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Thanks.

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter

