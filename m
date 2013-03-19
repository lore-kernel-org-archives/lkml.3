Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180Ab3CSNAE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 09:00:04 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:43966 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719Ab3CSNAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 09:00:01 -0400
Message-ID: <1363697998.21184.54.camel@edumazet-glaptop>
Subject: Re: [PATCH net-next 2/2] net: reset transport header if it was not
 set before transmission
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Daniel Borkmann <dborkman@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>, David Miller <davem@davemloft.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com,
        edumazet@google.com
Date: Tue, 19 Mar 2013 05:59:58 -0700
In-Reply-To: <514860DC.9020404@redhat.com>
References: <1363333305-54398-1-git-send-email-jasowang@redhat.com>
	  <1363333305-54398-2-git-send-email-jasowang@redhat.com>
	  <1363399851.29475.52.camel@edumazet-glaptop>
	  <20130317.121318.1869489921021513474.davem@davemloft.net>
	  <51482F55.8020900@redhat.com> <1363695234.21184.36.camel@edumazet-glaptop>
	 <514860DC.9020404@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-19 at 13:58 +0100, Daniel Borkmann wrote:

> Yes, will post them in a couple of minutes.
> 

Please target net tree for the first patch (adding thoff into struct
flow_keys), so that Jason or me can fix DODGY  providers.

Thanks


