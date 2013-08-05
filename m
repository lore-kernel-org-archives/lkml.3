Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655Ab3HEDdj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 23:33:39 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:38930 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754439Ab3HEDdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 23:33:38 -0400
Message-ID: <1375673616.3133.23.camel@joe-AO722>
Subject: Re: [PATCH] hostap: do not return positive number on failure path
 in prism2_open()
From: Joe Perches <joe@perches.com>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Jouni Malinen <j@w1.fi>, "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Date: Sun, 04 Aug 2013 20:33:36 -0700
In-Reply-To: <1375672708-3017-1-git-send-email-khoroshilov@ispras.ru>
References: <1375672708-3017-1-git-send-email-khoroshilov@ispras.ru>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-08-05 at 07:18 +0400, Alexey Khoroshilov wrote:
> prism2_open() as an .ndo_open handler should not return positive numbers
> in case of failure, but it does return 1 in a couple of places.
> 
> Found by Linux Driver Verification project (linuxtesting.org).

How?

http://linuxtesting.org/project/ldv
http://linuxtesting.org/results/ldv

Shows defects and patches to fix them, but not any script
used to find it.

