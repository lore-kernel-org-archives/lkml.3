Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964860AbaE3Qw1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 12:52:27 -0400
Received: from ns.horizon.com ([71.41.210.147]:51376 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751268AbaE3Qw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 12:52:26 -0400
Date: 30 May 2014 12:52:24 -0400
Message-ID: <20140530165224.14673.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, tim.c.chen@linux.intel.com
Subject: Re: [RFC PATCH] crypto: crc32c-pclmul - Use pmovzxdq to shrink K_table
Cc: herbert@gondor.apana.org.au, james.guilford@intel.com, JBeulich@suse.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <1401466248.2970.462.camel@schen9-DESK>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That's very small (less than 0.2%) so I think it's acceptable.

Thank you!  May I take this as an Acked-by; ?

I'll work on some performance improvements, but they proably
won't be ready for the 3.16 merge window.
