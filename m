Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209AbaBFVAn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 16:00:43 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:45027 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbaBFVAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 16:00:41 -0500
Message-ID: <1391720439.10160.13.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH] net: use __GFP_NORETRY for high order allocations
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 06 Feb 2014 13:00:39 -0800
In-Reply-To: <1391718270.15777.20.camel@joe-AO722>
References: <1391712162.10160.8.camel@edumazet-glaptop2.roam.corp.google.com>
	 <1391718270.15777.20.camel@joe-AO722>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-02-06 at 12:24 -0800, Joe Perches wrote:

> Perhaps add __GFP_THISNODE too ?

Why ?



