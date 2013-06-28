Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab3F1WIq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 18:08:46 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:35661 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751270Ab3F1WIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 18:08:44 -0400
Message-ID: <1372457323.29380.23.camel@joe-AO722>
Subject: Re: [PATCH net-next v4 1/2] lib: vsprintf: add IPv4/v6 generic
 %p[Ii]S[pfs] format specifier
From: Joe Perches <joe@perches.com>
To: Daniel Borkmann <dborkman@redhat.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 28 Jun 2013 15:08:43 -0700
In-Reply-To: <1372441780-9844-2-git-send-email-dborkman@redhat.com>
References: <1372441780-9844-1-git-send-email-dborkman@redhat.com>
	 <1372441780-9844-2-git-send-email-dborkman@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-28 at 19:49 +0200, Daniel Borkmann wrote:
> In order to avoid making code that deals with printing both, IPv4 and
> IPv6 addresses, unnecessary complicated as for example ...

Looks good to me.
Thanks Daniel for keeping at it.


