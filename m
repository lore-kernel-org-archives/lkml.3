Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757100Ab3GEHO3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 03:14:29 -0400
Received: from s3.sipsolutions.net ([144.76.43.152]:53390 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab3GEHO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 03:14:27 -0400
Message-ID: <1373008459.8548.0.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH] include: net: Add parameter desc to fix warning when
 generating docs
From: Johannes Berg <johannes@sipsolutions.net>
To: Sam Bristow <sam.bristow@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 05 Jul 2013 09:14:19 +0200
In-Reply-To: <1372972701-18323-1-git-send-email-sam.bristow@gmail.com> (sfid-20130704_231857_967925_7DC3A375)
References: <1372972701-18323-1-git-send-email-sam.bristow@gmail.com>
	 (sfid-20130704_231857_967925_7DC3A375)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-07-05 at 09:18 +1200, Sam Bristow wrote:
> 'make htmldocs' was generating a warning about a missing parameter description
> for gfp.

Thanks, but I already have it in my tree. Also, you forgot to sign off
on the patch anyway.

johannes

