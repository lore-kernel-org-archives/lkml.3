Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751261AbaLPOEo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 09:04:44 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:45713 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbaLPOEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 09:04:43 -0500
Date: Tue, 16 Dec 2014 17:04:18 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chris Rorvick <chris@rorvick.com>
Cc: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Fabian Frederick <fabf@skynet.be>, Julia Lawall <Julia.Lawall@lip6.fr>,
        "Dilger, Andreas" <andreas.dilger@intel.com>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        James Simmons <uja.ornl@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Drokin, Oleg" <oleg.drokin@intel.com>,
        Greg Donald <gdonald@gmail.com>,
        Andriy Skulysh <Andriy_Skulysh@xyratex.com>,
        "HPDD-discuss@ml01.01.org" <HPDD-discuss@ml01.01.org>,
        "Hammond, John" <john.hammond@intel.com>
Subject: Re: [PATCH] drivers: staging: lustre: Use mult if units not specified
Message-ID: <20141216140418.GK4856@mwanda>
References: <1418708509-18196-1-git-send-email-chris@rorvick.com>
 <20141216094109.GH4856@mwanda>
 <D0B55F56.D05F1%andreas.dilger@intel.com>
 <20141216113509.GI4856@mwanda>
 <CAEUsAPYTBq+0DGG909Rn0JhpF5Rh_6KbvmxS0wPQJ3j+qgZrEQ@mail.gmail.com>
 <20141216135459.GJ4856@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141216135459.GJ4856@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh wait... You're right.  This doesn't change the code how the code
works.  My bad.

Still, it's better to just remove the condition instead of making the
condition even more complicated and confusing.

regards,
dan carpenter

