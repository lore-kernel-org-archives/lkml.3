Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222AbaEFTZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 15:25:59 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:42081 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbaEFTZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 15:25:57 -0400
Message-ID: <1399404354.15399.64.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH 06/24] net, diet: Use small UDP hash tables on small
 kernels
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, tom.zanussi@linux.intel.com
Date: Tue, 06 May 2014 12:25:54 -0700
In-Reply-To: <20140506182344.GL19657@tassilo.jf.intel.com>
References: <1399328773-6531-1-git-send-email-andi@firstfloor.org>
	 <1399328773-6531-7-git-send-email-andi@firstfloor.org>
	 <1399386402.15399.11.camel@edumazet-glaptop2.roam.corp.google.com>
	 <20140506182344.GL19657@tassilo.jf.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-05-06 at 11:23 -0700, Andi Kleen wrote:

> Ok I need to fix that, because a single slot on a 2MB system 
> is likely not enough.

You have nothing to do.

It will use a 128 slots hash table with current code.



