Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861AbaG3Teb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 15:34:31 -0400
Received: from ja.ssi.bg ([178.16.129.10]:33478 "EHLO ja.home.ssi.bg"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753369AbaG3Tea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 15:34:30 -0400
Date: Wed, 30 Jul 2014 22:33:34 +0300 (EEST)
From: Julian Anastasov <ja@ssi.bg>
X-X-Sender: ja@ja.home.ssi.bg
To: Debabrata Banerjee <dbanerje@akamai.com>
cc: netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tcp: don't require root to read tcp_metrics
In-Reply-To: <1406740415-9386-1-git-send-email-dbanerje@akamai.com>
Message-ID: <alpine.LFD.2.11.1407302228460.1826@ja.home.ssi.bg>
References: <1406740415-9386-1-git-send-email-dbanerje@akamai.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


	Hello,

On Wed, 30 Jul 2014, Debabrata Banerjee wrote:

> commit d23ff701643a4a725e2c7a8ba2d567d39daa29ea introduced netlink support for
> the new tcp_metrics, however it restricted getting of tcp_metrics to root user
> only. This is a change from how these values could have been fetched when in
> the old route cache. Unless there's a legitimate reason to restrict the reading
> of these values it would be better if normal users could fetch them.

	Not sure how fatal is to show TCP fastopen cookies to
any user. Otherwise, I don't remember for other restrictions.

Regards

--
Julian Anastasov <ja@ssi.bg>
