Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933651Ab3GDWnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 18:43:18 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58794 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933309Ab3GDWnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 18:43:17 -0400
Message-ID: <1372977790.21065.141.camel@cumari.coelho.fi>
Subject: Re: [PATCH] include: net: Add parameter desc to fix waring when
 generating docs
From: Luciano Coelho <coelho@ti.com>
To: Sam Bristow <sam.bristow@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Date: Fri, 5 Jul 2013 01:43:10 +0300
In-Reply-To: <1372975190-21117-1-git-send-email-sam.bristow@gmail.com>
References: <1372975190-21117-1-git-send-email-sam.bristow@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-07-05 at 09:59 +1200, Sam Bristow wrote:
> 'make htmldocs' was generating a warning about a missing parameter description
> for gfp.
> 
> Earlier patch was missing my signed-off-by line...
> Signed-off-by: Sam Bristow <sam.bristow@gmail.com>
> ---

You have a typo in the patch subject (it was not there in your previous
version ;).

Also, you shouldn't add explanations about the different versions of the
patch in the commit message (in you case the "Earlier patch was missing
my signed-off-by line..." text).  If you want to add this kind of
comments, add it after the "---" under the Signed-of tags.

One more thing, it's a good idea to use [PATCH v2] when you're sending a
second version of the same patch.  That can be easily done with git
format-patch (and also with git send-email) by using an argument like
this: --subject-prefix="PATCH v2"

--
Luca.

