Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014Ab3KUH1o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 02:27:44 -0500
Received: from s3.sipsolutions.net ([144.76.43.152]:48983 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab3KUH1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 02:27:40 -0500
Message-ID: <1385018850.14273.0.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH] wimax: remove dead code
From: Johannes Berg <johannes@sipsolutions.net>
To: Joe Perches <joe@perches.com>
Cc: Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        inaky.perez-gonzalez@intel.com, linux-wimax@intel.com,
        davem@davemloft.net, wimax@linuxwimax.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 21 Nov 2013 08:27:30 +0100
In-Reply-To: <1385007469.2164.39.camel@joe-AO722>
References: <1385005391-18379-1-git-send-email-michael.opdenacker@free-electrons.com>
	 <1385007469.2164.39.camel@joe-AO722>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-11-20 at 20:17 -0800, Joe Perches wrote:
> On Thu, 2013-11-21 at 04:43 +0100, Michael Opdenacker wrote:
> > This removes a code line that is between a "return 0;" and an error label.
> > This code line can never be reached.
> 
> Adding Johannes Berg who added this oversight.

Obviously, sorry about that. I seem to remember deleting *something*
there (like another error label) but I guess I missed that line.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

johannes

